module Enumerable
  def my_each_with_index
    i = 0
    my_each do |elem|
      yield(elem, i)
      i += 1
    end
  end

  def my_select
    enumerable = self.class.new
    my_each do |elem|
      enumerable << elem if yield(elem)
    end
    enumerable
  end

  def my_all?
    my_each do |elem|
      return false unless yield(elem)
    end
    true
  end

  def my_any?
    my_each do |elem|
      return true if yield(elem)
    end
    false
  end

  def my_none?(&)
    !my_any?(&)
  end

  def my_count(arg = nil, &func)
    func ||= ->(_) { true } # Default to count all if no block
    func = ->(e) { e == arg } if arg # Override with equality check if arg is provided

    sum = 0
    my_each do |elem|
      sum += 1 if func.call(elem)
    end
    sum
  end
end

# You will first have to define my_each
# on the Array class. Methods defined in
# your enumerable module will have access
# to this method
class Array
  def my_each
    for elem in self # rubocop:disable Style/For
      yield elem
    end
    self
  end
end
