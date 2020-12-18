## Part1
class ExpA
  attr_reader :parts
  attr_reader :leftover
  def initialize(buffer)
    @parts = []
    if buffer.match? /\+\s*$/
      buffer = buffer.match(/(.*)\+\s*$/)[1]
      left = Expression.new(buffer)
      @leftover = left.leftover
      @parts = [left, "+"]
    elsif buffer.match? /\*\s*$/
      buffer = buffer.match(/(.*)\*\s*$/)[1]
      left = Expression.new(buffer)
      @leftover = left.leftover
      @parts = [left, "*"]
    else
      @parts = []
      @leftover = buffer
    end
  end

  def eval(s = 0)
    if parts.length == 0
      return s
    elsif parts[1] == "+"
      return s + parts[0].eval()
    elsif parts[1] == "*"
      return s * parts[0].eval()
    else
      raise "Expa Error"
    end
  end
end

class Expression
  attr_reader :parts
  attr_reader :leftover
  def initialize(buffer)
    @parts = []
    if buffer.match? /\d+\s*$/
      right = Integer(buffer.match(/(.*)(\d+)\s*$/)[2])
      buffer = buffer.match(/(.*)(\d+)\s*$/)[1]
      left = ExpA.new(buffer)
      @leftover = left.leftover
      @parts = [left, right]
    elsif buffer.match? /\)\s*$/
      buffer = buffer.match(/(.*)(\))\s*$/)[1]
      mid = Expression.new(buffer)
      buffer = mid.leftover
      if buffer.match? /\(\s*$/
        buffer = buffer.match(/(.*)(\()\s*$/)[1]
        left = ExpA.new(buffer)
        @leftover = left.leftover
        @parts = [left, mid]
      else
        raise "Invalid expression. Bad parenthesis"
      end
    else
      raise "Invalid expression, No matching option in: #{buffer}"
    end
  end
  
  def eval(s = 0)
    if @parts.length == 2
      if @parts[1].instance_of? Expression
        return @parts[0].eval(@parts[1].eval())
      else
        return @parts[0].eval(@parts[1])
      end
    else
      raise "parts should be 2"
    end
  end
end

test = [
  ["1", 1],
  ["(1)", 1],
  ["(1 + 1)", 2],
  ["1 + 1 * 2", 4],
  ["1 * 1 + 2", 3],
  ["1 + (1 * 2)", 3],
  ["5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))", 12240],
  ["((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", 13632]
]

for t in test
  exp = Expression.new(t[0])
  v = exp.eval()
  raise "#{t[0]} should be #{t[1]} instead of #{v}" unless v == t[1]
end
## End of Part1


## Part2

class Term
  attr_reader :parts
  attr_reader :leftover
  def initialize(buffer)
    @parts = []
    if buffer.match? /\)\s*$/
      buffer = buffer.match(/(.*)\)\s*$/)[1]
      a = Mul.new(buffer)
      buffer = a.leftover
      @parts = [a]
      buffer = buffer.match(/(.*)\(\s*$/)[1]
      @leftover = buffer
    elsif buffer.match? /\d+\s*$/
      value = buffer.match(/(.*)(\d+)\s*$/)[2]
      buffer = buffer.match(/(.*)\d+\s*$/)[1]
      @leftover = buffer
      @parts = [Integer(value)]
    end
  end

  def eval(s = 0)
    if @parts.length == 1
      if @parts[0].instance_of? Mul
        return @parts[0].eval()
      end
      return @parts[0]
    end
    raise "Error"
  end
end

class AddV
  attr_reader :parts
  attr_reader :leftover
  def initialize(buffer)
    @parts = []
    if buffer.match? /\+\s*$/
      buffer = buffer.match(/(.*)\+\s*$/)[1]
      a = Add.new(buffer)
      @leftover = a.leftover
      @parts = [a]
    else
      @pars = []
      @leftover = buffer
    end
  end
  def eval(s = 0)
    if @parts.length == 1
      return s + @parts[0].eval()
    end
    return s
  end
end

class Add
  attr_reader :parts
  attr_reader :leftover
  def initialize(buffer)
    a = Term.new(buffer)
    buffer = a.leftover
    b = AddV.new(buffer)
    @leftover = b.leftover
    @parts = [a, b]
  end

  def eval(s = 0)
    return @parts[1].eval(@parts[0].eval())
  end
end

class MulV
  attr_reader :parts
  attr_reader :leftover
  def initialize(buffer)
    @parts = []
    if buffer.match? /\*\s*$/
      buffer = buffer.match(/(.*)\*\s*$/)[1]
      a = Add.new(buffer)
      buffer = a.leftover
      b = MulV.new(buffer)
      @parts = [a, b]
      @leftover = b.leftover
    else
      @part = []
      @leftover = buffer
    end
  end

  def eval(s = 0)
    if @parts.length == 2
      return s * @parts[1].eval(@parts[0].eval())
    else
      return s
    end
  end
end

class Mul
  attr_reader :parts
  attr_reader :leftover
  def initialize(buffer)
    a = Add.new(buffer)
    buffer = a.leftover
    b = MulV.new(buffer)
    @leftover = b.leftover
    @parts = [a, b]
  end
  
  def eval(s = 0)
    return @parts[1].eval(@parts[0].eval())
  end
end



test = [
  ["1", 1],
  ["(1)", 1],
  ["(1 + 1)", 2],
  ["1 + 1 * 2", 4],
  ["1 + (1 * 2)", 3],
  ["((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", 23340]
]

for t in test
  exp = Mul.new(t[0])
  v = exp.eval()
  raise "#{t[0]} should be #{t[1]} instead of #{v}" unless v == t[1]
end

## End of Part2

file = File.open("../input.txt")
lines = file.readlines.map(&:chomp)
file.close

ans1 = 0
ans2 = 0
for l in lines
  exp = Expression.new(l)
  ans1 += exp.eval()
  exp = Mul.new(l)
  ans2 += exp.eval()
end
puts "Task1 solution: #{ans1}"
puts "Task2 solution: #{ans2}"