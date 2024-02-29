class SymbolTable
  def initialize
    @class_table = {}
    @subroutine_table = {}
  end

  def start_subroutine
    @subroutine_table = {}
  end

  def define(name, type, kind)
    if kind == "static" || kind == "field"
      @class_table[name] = { type: type, kind: kind, index: @class_table.keys.count }
    else
      @subroutine_table[name] = { type: type, kind: kind, index: @subroutine_table.keys.count }
    end
  end

  def var_count(kind)
    if kind == "static" || kind == "field"
      @class_table.values.count { |value| value[:kind] == kind }
    else
      @subroutine_table.values.count { |value| value[:kind] == kind }
    end
  end

  def kind_of(name)
    if @subroutine_table.key?(name)
      @subroutine_table[name][:kind]
    elsif @class_table.key?(name)
      @class_table[name][:kind]
    else
      'NONE'
    end
  end

  def type_of(name)
    if @subroutine_table.key?(name)
      @subroutine_table[name][:type]
    elsif @class_table.key?(name)
      @class_table[name][:type]
    else
      'NONE'
    end
  end

  def index_of(name)
    if @subroutine_table.key?(name)
      @subroutine_table[name][:index]
    elsif @class_table.key?(name)
      @class_table[name][:index]
    else
      'NONE'
    end
  end
end