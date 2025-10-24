"""
This file defines helper scripts for Zeek development for GDB. Currently
it provides:

- A new 'btz' command that outputs a backtrace containing Zeek script
  location information for frames that have that data.

Use this by either manually loading it in gdb by calling:

    source /path/to/zeek-gdb-utils.py

Or by adding the same line to a .gdbinit file in your home directory.
"""

import os
import re
import shutil
import traceback
from linecache import getline

import gdb
import gdb.types

try:
    from ansi.color import fg
    from ansi.color.fx import reset
except ImportError:
    # This is sort of gross, but allows users to get away without having the ansi module.
    TempAscii = type(
        "TempAscii",
        (object,),
        {
            "blue": "\x1b[34m",
            "green": "\x1b[32m",
            "yellow": "\x1b[33m",
            "cyan": "\x1b[36m",
        },
    )
    fg = TempAscii()
    reset = "\x1b[0m"

# Cache script lines and files so that we don't have to load files repeatedly
script_lines = {}


class BtzFramePrinter:
    def format_frame(self, initial_frame: gdb.Frame) -> str:
        """
        Builds a backtrace starting a frame, including Zeek script information if a
        specific frame in the trace has location data. Unlike LLDB, where you can
        just modify a frame in an existing backtracee with the script info, GDB's
        Python API requires us to completely rebuild the backtrace from scratch. This
        means a lot of extra machinery for both moving through the stack as well as
        formatting the output to be as close to the existing output of 'bt' as
        possible.
        """
        line_width = shutil.get_terminal_size((80, 20)).columns

        full_bt = ""
        cur_frame = initial_frame
        frame_count = 0
        while cur_frame:
            frame_count += 1
            cur_frame = cur_frame.older()

        try:
            cur_frame = initial_frame
            while cur_frame:
                frame_output = f"#{cur_frame.level():<2} "
                if cur_frame != initial_frame:
                    frame_output += f"{fg.blue}0x{cur_frame.pc():016x}{reset} in "

                frame_output += f"{fg.yellow}{cur_frame.name()}{reset}"

                block = cur_frame.block()
                frame_output += " ("
                args = []
                this_sym = None
                while block:
                    if not block.is_global and not block.is_static:
                        for sym in block:
                            if not sym.is_argument:
                                continue
                            if sym.print_name == "this":
                                this_sym = sym

                            args.append(
                                f"{fg.cyan}{sym.print_name}{reset}={sym.value(cur_frame)}"
                            )

                    block = block.superblock

                frame_output += ", ".join(args)
                frame_output += ") "
                frame_output = self.wrap_line(frame_output, line_width)

                sal = cur_frame.find_sal()
                file_at = f"at {fg.green}{sal.symtab.filename}{reset}:{sal.line}"

                parts = frame_output.split("\n")
                if (
                    len(self.strip_ansi(parts[-1])) + len(self.strip_ansi(file_at))
                    > line_width
                ):
                    frame_output += "\n    "

                frame_output += file_at

                script_info = self.build_script_info_string(this_sym, cur_frame)
                if script_info:
                    frame_output += f"\n{script_info}"

                if cur_frame.older():
                    frame_output += "\n"

                full_bt += frame_output
                cur_frame = cur_frame.older()
        except Exception as e:
            print(traceback.format_exc())
            print(e)

        return full_bt

    def build_script_info_string(self, sym: gdb.Symbol, cur_frame: gdb.Frame) -> str:
        """
        Builds a string containing the filename and line of code for a position in
        a Zeek script called by a frame.
        """
        script_info = ""

        if sym:
            this_val = sym.value(cur_frame)
            if this_val.is_optimized_out:
                return None

            if this_val.type.code == gdb.TYPE_CODE_PTR:
                this_val = this_val.dereference()

                if not gdb.types.has_field(this_val.type, "location"):
                    return None

                loc = this_val["location"]
                if loc.type.code == gdb.TYPE_CODE_PTR:
                    loc = loc.dereference()

                if not gdb.types.has_field(
                    loc.type, "filename"
                ) or not gdb.types.has_field(loc.type, "first_line"):
                    return None

                if loc["filename"].address == 0:
                    return None

                fname = loc["filename"].string()
                line_no = int(loc["first_line"])

                script_info = f"        {fg.green}zeek script:{reset} {fname.strip()}"

                if os.path.exists(fname):
                    fileinfo = f"{fname}:{line_no}"
                    if fileinfo in script_lines:
                        line = script_lines[fileinfo]
                    else:
                        line = getline(fname, line_no)
                        line = line.strip()
                        script_lines[fileinfo] = line

                    if line:
                        line_hdr = f"line {line_no}"
                        script_info += (
                            f"\n        {fg.green}{line_hdr: >11}:{reset} {line}"
                        )

        return script_info

    def strip_ansi(self, text: str) -> str:
        """
        Removes ANSI escape sequences from a string.
        """
        ansi_escape = re.compile(r"\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])")
        return ansi_escape.sub("", text)

    def wrap_line(self, text: str, line_width: int) -> str:
        """
        Wraps the lines of a string to a specific length, breaking at spaces.
        """
        parts = text.split(" ")
        output = ""
        line = 1
        start_of_line = True

        for p in parts:
            if len(self.strip_ansi(output)) + len(self.strip_ansi(p)) + 1 > (
                line_width * line
            ):
                output += "\n    "
                start_of_line = True
                line += 1

            if not start_of_line:
                output += " "
            else:
                start_of_line = False

            output += p

        return output


class BTZ(gdb.Command):
    def __init__(self):
        super().__init__("btz", gdb.COMMAND_STACK)

    def invoke(self, arg, from_tty):
        try:
            btz = BtzFramePrinter()
            print(btz.format_frame(gdb.newest_frame()))
        except gdb.error:
            print(traceback.format_exc())


BTZ()
