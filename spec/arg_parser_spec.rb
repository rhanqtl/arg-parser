#!/usr/bin/env ruby

require "rspec/autorun"

require "./arg_parser.rb"

describe ArgumentParser do
  it "should raise an exception if `option_name` is nil" do
    parser = ArgumentParser.new
    expect {
      parser.add_option nil
    }.to raise_error(ArgumentError)
  end

  it "should raise an exception if `option_name` is empty" do
    parser = ArgumentParser.new
    expect {
      parser.add_option ""
    }.to raise_error(ArgumentError)
  end

  it "should raise an exception if `option_name` is duplicate" do
    parser = ArgumentParser.new
    parser.add_option "--pass"
    expect {
      parser.add_option "--pass"
    }.to raise_error(DuplicateError)
  end

  it "should raise an exception if parameter_type.class is none of Symbol/String/Regexp/nil" do
    parser = ArgumentParser.new
    expect {
      parser.add_option "--pass", 1
    }.to raise_error(UnsupportedParameterTypeError)
  end

  it "should return empty array if `argv` is nil" do
    parser = ArgumentParser.new
    parser.add_option "--force", nil, "-f"
    parser.add_option "--lines", :dec, "-l"
    expect(parser.parse nil).to eq([])
  end

  it "should return parsed arguments" do
    parser = ArgumentParser.new
    parser.add_option "--force", nil, "-f"
    parser.add_option "--lines", :dec, "-l"
    expect(parser.parse ["--force", "-l", "123"]).to eq([["--force"], ["--lines", "123"]])
  end
end