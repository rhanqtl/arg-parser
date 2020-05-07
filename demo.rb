#!/usr/bin/env ruby

require "./arg_parser.rb"

parser = ArgumentParser.new

parser.add_option "--force", nil, "-f"
parser.add_option "--lines", :dec, "-l"

# assuming `ARGV` is ["--force", "--lines", "123"]
p parser.parse ARGV
