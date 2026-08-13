#!/usr/bin/env python3

"""
This generates a set of patch notes from the current set of draft Github Security
Advisories. It comes with two output modes. The default is a "short" version that includes
the severity and subject for each, plus a link to the advisory. The long version,
controlled by an argument, interleaves the description of the GHSA after each entry. It
can also output as, Markdown, PDF, and a format suitable for Zeek's NEWS file.
"""

import argparse
import os
import sys
import textwrap
from contextlib import redirect_stdout
from io import StringIO

try:
    import requests
except ImportError as err:
    print(f"This script requires the 'requests' Python module: {err}")
    sys.exit(1)

# This token requires permissions to read security advisories. If the token only has
# repository-read permissions, the API will silently return an empty array.
GH_TOKEN = os.getenv("GH_TOKEN", "")

if not GH_TOKEN:
    sys.exit("GH_TOKEN environment variable required")

parser = argparse.ArgumentParser()
parser.add_argument(
    "--long",
    "-l",
    action="store_true",
    help="Generate longer version for PDG release notes",
)
parser.add_argument(
    "--output",
    "-o",
    type=str,
    help="The filename of the output. Sends to stdout if this option is missing.",
)
parser.add_argument(
    "--type",
    "-t",
    choices=["markdown", "pdf", "news"],
    default="markdown",
    help="The type of output",
)

args = parser.parse_args()

if args.type == "pdf":
    if not args.output:
        print("PDF output requires an '--output' argument for a destination file")
        sys.exit(1)

    try:
        from markdown_pdf import MarkdownPdf, Section
    except ImportError as err:
        print(f"PDF mode requires the 'markdown_pdf' Python module: {err}")
        sys.exit(1)

headers = {
    "Accept": "application/vnd.github+json",
    "Authorization": f"Bearer {GH_TOKEN}",
}

url = "https://api.github.com/repos/zeek/zeek/security-advisories"
req = requests.get(url, headers=headers)
resp_json = req.json()

severity_order = ["critical", "high", "medium", "low"]
severity_match = {value: index for index, value in enumerate(severity_order)}
resp_json.sort(key=lambda x: severity_match[x["severity"]])

output = ""
with redirect_stdout(StringIO()) as f:
    for sa in resp_json:
        # Since we're generating patch notes, we want to ignore anything that's not in
        # a draft state.
        if sa.get("state", "") == "draft":
            ghsa_id = sa.get("ghsa_id")
            summary = sa.get("summary")
            severity = sa.get("severity")
            severity = severity.upper()

            ghsa_link = f"Advisory: [{ghsa_id}](https://github.com/zeek/zeek/security/advisories/{ghsa_id})"

            if args.type == "news":
                print(f"- {severity}: {summary}")
                print(f"  {ghsa_link}")
            else:
                print(f"{severity}: {summary}\\")
                print(f"{ghsa_link}")

            if args.long:
                desc_lines = sa.get("description", "").splitlines()
                for line in desc_lines:
                    wrapped = textwrap.fill(line, width=80)
                    if len(wrapped) == 0:
                        print(">")
                    else:
                        section = "\n".join(["> " + wl for wl in wrapped.splitlines()])
                        print(section)

            print()

output = f.getvalue()

if args.type == "pdf":
    pdf = MarkdownPdf(toc_level=2)
    pdf.add_section(Section(output))
    pdf.save(args.output)
else:
    if args.output:
        with open(args.output, "w") as out:
            out.write(output)
    else:
        print(output)
