# Command Line Argument Parser

implemented in Ruby

## Directory Structure

```
.
├── README.md
├── arg_parser.rb
├── exceptions
│   ├── duplicate_error.rb
│   └── unsupported_param_type_error.rb
├── spec
│   ├── arg_parser_spec.rb
│   └── trie_spec.rb
└── trie.rb
```

`arg_parser.rb` is the source code file of `ArgumentParser`

`spec` is the directory of unit tests

## Documentation

`demo.rb`:

```Ruby
require "./arg_parser.rb"

parser = ArgumentParser.new

parser.add_option "--force", nil, "-f"
parser.add_option "--lines", :dec, "-l"

# assuming `ARGV` is ["--force", "--lines", "123"]
p parser.parse ARGV
```

Output:

```
[["--force"], ["--lines", "123"]]
```
