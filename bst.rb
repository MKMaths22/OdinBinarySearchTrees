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

  def initialize(values_array = [])
    @values_array = prepare_array(values_array)
    # values_array sorted with no duplicates
    @root = build_tree
  end

  def build_tree

  end

  def prepare_array(any_array)
    any_array.uniq!
    array = merge_sort(any_array)
  end

end

