class SymbolTable
  attr_reader :static_table, :field_table, :arg_table, :var_table

  KINDS = %w[STATIC FIELD ARG VAR]
  def initialize
    @static_table = {}
    @field_table = {}
    @arg_table = {}
    @var_table = {}
  end

  def start_subroutine
    @var_table = {}
    @arg_table = {}
  end

  def define(name, type, kind)
    unless KINDS.include?(kind)
      raise "Invalid kind: #{kind}"
    end

    table = select_table(kind)
    index = var_count(kind)
    table[name] = { type: type, kind: kind, index: index }
  end

  def var_count(kind)
    select_table(kind).size
  end

  def kind_of(name)
    symbol = select_table_by_name(name)
    symbol ? symbol[:kind] : 'NONE'
  end

  def type_of(name)
    select_table_by_name(name)[:type]
  end


  def index_of(name)
    select_table_by_name(name)[:index]
  end

  private

  def select_table(kind)
    case kind
    when "STATIC"
      @static_table
    when "FIELD"
      @field_table
    when "ARG"
      @arg_table
    when "VAR"
      @var_table
    end
  end

  def select_table_by_name(name)
    @var_table[name] || @arg_table[name] || @field_table[name] || @static_table[name]
  end
end