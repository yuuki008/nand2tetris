require_relative '../../jack_tokenizer'
require 'minitest/autorun'

class JackTokenizerTest < Minitest::Test
  describe "token_type" do
    def test_keyword
      tokenizer = JackTokenizer.new("tests/jack_tokenizer/test.jack")

      JackTokenizer::KEYWORDS.each do |key, value|
        assert_equal "KEYWORD", tokenizer.token_type(key)
      end
    end

    def test_symbol
      tokenizer = JackTokenizer.new("tests/jack_tokenizer/test.jack")

      JackTokenizer::SYMBOLS.each do |symbol|
        assert_equal "SYMBOL", tokenizer.token_type(symbol)
      end
    end

    def test_int_const
      tokenizer = JackTokenizer.new("tests/jack_tokenizer/test.jack")

      assert_equal "INT_CONST", tokenizer.token_type("123")
      assert_equal "INT_CONST", tokenizer.token_type("0")
    end

    def test_string_const
      tokenizer = JackTokenizer.new("tests/jack_tokenizer/test.jack")

      puts tokenizer.token_type('"string constant"')
      assert_equal "STRING_CONST", tokenizer.token_type('"Hello"')
      assert_equal "STRING_CONST", tokenizer.token_type('"string constant"')
    end

    def test_identifier
      tokenizer = JackTokenizer.new("tests/jack_tokenizer/test.jack")

      assert_equal "IDENTIFIER", tokenizer.token_type('hoge')
    end
  end

  describe 'advance' do
    def test_advance
      tokenizer = JackTokenizer.new("tests/jack_tokenizer/test.jack")

      file = File.open("tests/jack_tokenizer/test.jack")
      tokens = file.read.split(/(\s+|\{|}|\(|\)|\[|\]|\.|,|;|\+|-|\*|\/|&|\||<|>|=|~)/).reject { |token| token.strip.empty? }

      tokens.each do |token, index|
        assert_equal token, tokens[tokenizer.index]
        tokenizer.advance
      end
    end
  end

  describe 'execute' do
    def test_output_xml
      tokenizer = JackTokenizer.new("tests/jack_tokenizer/test.jack")
      tokenizer.execute

      expected = File.read("tests/jack_tokenizer/testTT.xml").strip.gsub(/\n/, '')
      actual = File.read(tokenizer.output_file.path).strip.gsub(/\n/, '')

      assert_equal expected, actual
      File.delete(tokenizer.output_file.path)
    end
  end
end
