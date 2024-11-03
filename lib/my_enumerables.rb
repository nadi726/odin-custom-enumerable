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
