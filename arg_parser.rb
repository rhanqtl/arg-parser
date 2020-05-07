require "./trie.rb"
require "./exceptions/unsupported_param_type_error.rb"
require "./exceptions/duplicate_error.rb"

class ArgumentParser
  @@ANY = /^.*$/
  @@DEC = /^\d+$/
  @@HEX = /^0x[0-9a-fA-F]+$/
  @@OCT = /^0o[0-7]+$/
  @@ANY_INT = Regexp.union(@@DEC, @@HEX, @@OCT)
  @@FLOAT = /^[\+-]?\d*\.\d*([eE][+-]?\d*)?$/
  @@ANY_NUMBER = Regexp.union(@@ANY_INT, @@FLOAT)
  # /etc/pacman.d
  # /etc/pacman.d/
  # etc/pacman.d
  # etc/pacman.d/
  # TODO: exclude empty string
  @@PATHNAME = /^\/?([^\/\\]+\/)*([^\/\\]+)?$/

  @@type_to_regex = {
    any: @@ANY,
    dec: @@DEC,
    hex: @@HEX,
    oct: @@OCT,
    any_int: @@ANY_INT,
    float: @@FLOAT,
    any_number: @@ANY_NUMBER,
    pathname: @@PATHNAME
  }

  def initialize
    @trie = Trie.new
    @formats = {}
    @aliases = {}
  end

  def add_option(option_name, parameter_type=nil, short_name=nil)
    if option_name.nil? or option_name.empty?
      raise ArgumentError.new "argument `option_name` must not be nil or empty"
    end
    
    if @formats.include? option_name
      raise DuplicateError.new "duplicate option name: #{option_name}"
    end

    case parameter_type.class.name
    when :dummy.class.name
      # if `parameter_type` is a string
      if not @@type_to_regex.include? parameter_type
        raise UnsupportedParameterTypeError.new "unsupported parameter type: #{parameter_type.to_s}"
      end
      parameter_type = @@type_to_regex[parameter_type]
    when "dummy".class.name
      if not @@type_to_regex.include? parameter_type.to_sym
        raise UnsupportedParameterTypeError.new "unsupported parameter type: #{parameter_type}"
      end
      parameter_type = @@type_to_regex[parameter_type.to_sym]
    when @@ANY.class.name
      # if `parameter_type` is a regex
    when nil.class.name
      # if `parameter_type` is nil, no parameter is required
    else
      raise UnsupportedParameterTypeError.new "argument `parameter_type` should be a string or regex"
    end

    if not short_name.nil? and not short_name.empty?
      if @aliases.include? short_name
        raise DuplicateError.new "duplicate short name"
      end
      @aliases[short_name] = option_name
    end

    @formats[option_name] = parameter_type
    @trie.insert! option_name
  end

  def parse(argv)
    result = []
    if argv.nil?
      return result
    end
    e = argv.each
    loop do
      begin
        option_name = e.next
        if @trie.find option_name
          # do nothing
        elsif @aliases.include? option_name and @trie.find @aliases[option_name]
          option_name = @aliases[option_name]
        else
          raise ArgumentError.new "unrecognized option_name: #{option_name}"
        end
        if @formats.include? option_name
          if @formats[option_name].nil?
            result.append [option_name]
          else
            param = e.next
            if param =~ @formats[option_name]
              result.append [option_name, param]
            else
              raise ArgumentError.new "format error: option: #{option_name}, param: #{param}"
            end
          end
        end
      rescue
        break
      end
    end
    return result
  end
end