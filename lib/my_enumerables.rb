# frozen_string_literal: true

# Custom enumerable methods, relying on my_each
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

  def my_map
    arr = []
    my_each do |elem|
      arr << yield(elem)
    end
    arr
  end

  def my_inject(initial_value, symbol = nil, &func)
    return nil if initial_value.nil? && my_first.nil?

    func = ->(result, elem) { result.send(symbol, elem) } if symbol
    result = initial_value || my_first
    enumerable = initial_value ? self : my_rest # skip the first element only if no initial value is given

    enumerable.my_each do |elem|
      result = func.call(result, elem)
    end
    result
  end

  # Return the first element of self, or nil if self is empty
  def my_first
    my_each { |e| return e }
  end

  # iterate over all of self, skipping the first element
  def my_rest
    is_first = true
    my_each do |elem|
      yield(elem) unless is_first
      is_first = false
    end
  end
end

# Extend Array with the custom my_each method; required for the custom enumerable methods
class Array
  def my_each
    for elem in self # rubocop:disable Style/For
      yield elem
    end
    self
  end
end
