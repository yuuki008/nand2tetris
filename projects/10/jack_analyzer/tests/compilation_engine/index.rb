require_relative '../../compilation_engine'
require_relative "../../jack_tokenizer"
require 'minitest/autorun'

class CompilationEngineTest < Minitest::Test
  def test_compile_class
    tokenizer = JackTokenizer.new(File.join(__dir__, 'test.jack'))
    CompilationEngine.new(tokenizer)

    expected = File.read(File.join(__dir__, 'test.expected.xml')).gsub(/\s+/, "").chomp
    actual = File.read(File.join(__dir__, 'test.xml')).gsub(/\s+/, "").chomp

    assert_equal expected, actual
  end 
end