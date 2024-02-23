require_relative '../../jack_tokenizer'
require 'minitest/autorun'

class JackTokenizerTest < Minitest::Test
  describe 'advance' do
    def test_advance
      tokenizer = JackTokenizer.new("tests/jack_tokenizer/test.jack")

      tokenizer.tokens.each do |token, index|
        assert_equal token, tokenizer.token
        tokenizer.advance
      end
    end
  end

  describe 'initialize' do
    def test_exclude_comments
      tokenizer = JackTokenizer.new("tests/jack_tokenizer/test.jack")

      expected = ["if", "(", "x", "<", "153", ")", "{", "let", "city", "=", "\"Paris\"", ";", "}"]

      assert_equal expected, tokenizer.tokens
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
