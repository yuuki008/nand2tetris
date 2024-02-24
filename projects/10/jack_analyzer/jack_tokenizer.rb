class JackTokenizer
  attr_reader :input_file_path, :index, :token, :tokens, :output_file

  TOKEN_TYPES = {
    'KEYWORD' => 'keyword',
    'SYMBOL' => 'symbol',
    'IDENTIFIER' => 'identifier',
    'INT_CONST' => 'integerConstant',
    'STRING_CONST' => 'stringConstant'
  }.freeze

  KEYWORDS = {
    'class' => 'CLASS',
    'method' => 'METHOD',
    'function' => 'FUNCTION',
    'constructor' => 'CONSTRUCTOR',
    'int' => 'INT',
    'boolean' => 'BOOLEAN',
    'char' => 'CHAR',
    'void' => 'VOID',
    'var' => 'VAR',
    'static' => 'STATIC',
    'field' => 'FIELD',
    'let' => 'LET',
    'do' => 'DO',
    'if' => 'IF',
    'else' => 'ELSE',
    'while' => 'WHILE',
    'return' => 'RETURN',
    'true' => 'TRUE',
    'false' => 'FALSE',
    'null' => 'NULL',
    'this' => 'THIS'
  }.freeze

  SYMBOLS = [
    '{',
    '}',
    '(',
    ')',
    '[',
    ']',
    '.',
    ',',
    ';',
    '+',
    '-',
    '*',
    '/',
    '&',
    '|',
    '<',
    '>',
    '=',
    '~',
    '<',
    '>',
    '&',
  ].freeze

  ESCAPED_SYMBOLS = {
    '<' => '&lt;',
    '>' => '&gt;',
    '&' => '&amp;',
  }

  def initialize(file_path)
    @input_file_path = file_path
    file = File.read(file_path)
    text_without_cross_line_comments = file.gsub(%r{/\*\*(.*?)\*/}m, '')
    text_without_comments = text_without_cross_line_comments.lines.map { |line| line.strip.gsub(/\/\/.*$/, '').chomp }
    @tokens = text_without_comments.join.split(/("[^"\\]*(?:\\.[^"\\]*)*"|\s+|\{|}|\(|\)|\[|\]|\.|,|;|\+|-|\*|\/|&|\||<|>|=|~)/).reject { |token| token.strip.empty? }
    @index = 0
    @output_file = File.open(file_path.gsub('.jack', 'T.xml'), 'w')
  end

  def token
    @tokens[@index]
  end

  def next_token
    @tokens[@index + 1]
  end

  def escape_token
    if token_type === 'SYMBOL'
      return ESCAPED_SYMBOLS[token] || token
    elsif token_type === 'STRING_CONST'
      return token[1..-2]
    else
      return token
    end
  end

  def execute
    write_code('<tokens>')

    while has_more_tokens?
      case token_type
      when 'KEYWORD'
        write_code("<keyword> #{escape_token} </keyword>")
      when 'SYMBOL'
        write_code("<symbol> #{escape_token} </symbol>")
      when 'IDENTIFIER'
        write_code("<identifier> #{escape_token} </identifier>")
      when 'INT_CONST'
        write_code("<integerConstant> #{escape_token} </integerConstant>")
      when 'STRING_CONST'
        write_code("<stringConstant> #{escape_token} </stringConstant>")
      end

      advance()
    end

    write_code('</tokens>')

    @output_file.close
  end

  def has_more_tokens?
    @index < @tokens.length
  end

  def advance
    @index += 1
  end

  def token_type
    if KEYWORDS.include?(token)
      return 'KEYWORD'
    elsif SYMBOLS.include?(token)
      return 'SYMBOL'
    elsif token =~ /\A\d+\z/
      return 'INT_CONST'
    elsif token[0] == '"' && token[-1] == '"'
      return 'STRING_CONST'
    else
      return 'IDENTIFIER'
    end
  end

  def keyword
    raise 'Not a keyword' unless token_type === 'KEYWORD'

    token
  end

  def symbol
    raise 'Not a symbol' unless token_type === 'SYMBOL'

    token
  end

  def identifier
    raise 'Not an identifier' unless token_type === 'IDENTIFIER'

    token
  end

  def int_val
    raise 'Not an integer constant' unless token_type === 'INT_CONST'

    token
  end

  def string_val
    raise 'Not a string constant' unless token_type === 'STRING_CONST'

    token
  end

  private

  def write_code(code)
    @output_file.write("#{code}\n")
  end

  def write_codes(codes)
    codes.each do |code|
      write_code(code)
    end
  end
end