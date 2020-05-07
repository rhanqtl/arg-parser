require "rspec/autorun"

require "./trie.rb"

describe Trie do
  it "returns false when no match" do
    t = Trie.new
    expect(t.find "--pass").to eq(false)
  end

  it "returns true when match" do
    t = Trie.new
    t.insert! "--pass"
    expect(t.find "--pass").to eq(true)
  end
end