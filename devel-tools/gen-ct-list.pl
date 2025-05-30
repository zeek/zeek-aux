#!/usr/bin/env perl
#
# Generate the Zeek file containing the current list of known
# Certificate Transparency logs from the source file provided
# by Google.
#

use 5.14.1;
use strict;
use warnings;

# This is the only kind-of user-configurable line

my $google_log_url = "https://www.gstatic.com/ct/log_list/v3/log_list.json";

# And begin with loading everything we need.
# I was lazy and you probably will have to install a few of these.

use Carp;
use autodie;
use Net::SSLeay;
use HTML::HeadParser;
use LWP::Protocol::https;
use LWP::UserAgent;
use LWP::Simple;
use JSON::Parse qw/parse_json/;
use MIME::Base64;
use Digest::SHA qw/sha256/;
use Mozilla::CA;

my $ua = LWP::UserAgent->new();
my $google_known_logs_json = $ua->get($google_log_url);
croak("Could not get $google_log_url") unless defined($google_known_logs_json);

my $list = parse_json($google_known_logs_json->content);

say "#\n# Do not edit this file. This file is automatically generated by gen-ct-list.pl";
say "# File generated at ".localtime;
say "# File generated from ".$google_log_url;
say "# Source file generated at: ".$list->{log_list_timestamp};
say "# Source file version: ".$list->{version};
say "#";
say "";
say '@load base/protocols/ssl';
say "module SSL;";
say "";
say '## @docs-omit-value';
say "redef ct_logs += {";

for my $operator (@{$list->{operators}}) {
	my $opname = $operator->{name};
	for my $log (@{$operator->{logs}}) {
		my $key = join('', map {"\\x$_" } unpack("(H2)*", decode_base64($log->{key})));
		my $logid = join('', map {"\\x$_" } unpack("(H2)*", sha256(decode_base64($log->{key}))));
		my $mmd = $log->{mmd};
		my $url = $log->{url};
		my $desc = $log->{description};
		say "[\"$logid\"] = CTInfo(\$description=\"$desc\", \$operator=\"$opname\", \$url=\"$url\", \$maximum_merge_delay=$mmd, \$key=\"$key\"),";
	}
}

say "};";
