require_relative "../../jack_analyzer"
require "minitest/autorun"

class JackAnalyzerTest < Minitest::Test
  def test_array_test
    dir_path = dir_path("ArrayTest")

    JackAnalyzer.new(dir_path).execute

    expected = File.read(File.join(dir_path, "Main.xml.expected")).gsub(/\s+/, "").chomp
    actual = File.read(File.join(dir_path, "Main.xml")).gsub(/\s+/, "").chomp

    assert_equal expected, actual
  end

  def test_expression_less_square
    dir_path = dir_path("ExpressionLessSquare")

    JackAnalyzer.new(dir_path).execute

    expected_files(dir_path).each_with_index do |file, index|
      expected_file_name = File.basename(file)

      actual_file_name = expected_file_name.gsub(".expected", "")
      actual_file = actual_files(dir_path).find { |file_path| File.basename(file_path) == actual_file_name }

      expected = File.read(file).gsub(/\s+/, "").chomp
      actual = File.read(actual_file).gsub(/\s+/, "").chomp

      assert_equal expected, actual
    end
  end

  def test_square
    dir_path = dir_path("Square")

    JackAnalyzer.new(dir_path).execute

    expected_files(dir_path).each_with_index do |file, index|
      expected_file_name = File.basename(file)

      actual_file_name = expected_file_name.gsub(".expected", "")
      actual_file = actual_files(dir_path).find { |file_path| File.basename(file_path) == actual_file_name }

      expected = File.read(file).gsub(/\s+/, "").chomp
      actual = File.read(actual_file).gsub(/\s+/, "").chomp

      assert_equal expected, actual
    end
  end

  private
  
  def dir_path(dir_name)
    current_dir = File.expand_path(__dir__)
    File.join(current_dir, "../../../#{dir_name}")
  end

  def expected_files(dir_path)
    Dir.glob("#{dir_path}/*.xml.expected").reject { |file| file.include?("T.xml") }
  end

  def actual_files(dir_path)
    Dir.glob("#{dir_path}/*.xml").reject { |file| file.include?("T.xml") }
  end
end