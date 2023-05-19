# frozen_string_literal: true

require_relative 'merge_sort'

class Node

  include Comparable

  def initialize(value, left_child = nil, right_child = nil)
    @value = value
    @left_child = left_child
    @right_child = right_child
  end


end


# Tree class is for the binary search trees
class Tree

  include MergeSort

end

puts merge_sort([1,3,5,0])