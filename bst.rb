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

  attr_reader :root
  
  def initialize(values_array = [])
    array_to_use = prepare_array(values_array)
    # values_array sorted with no duplicates
    @root = build_tree(array_to_use)
  end

  def build_tree(array)
    return nil if array.size.zero?
    mid_index = array.size / 2
    mid_value = array[mid_index]
    left_values = array.slice!(0, mid_index)
    array.shift
    # shift removes the middle value of the original array here
    right_values = array
    # we modified array in place so right_values is what remains
    root = Node.new(mid_value, build_tree(left_values), build_tree(right_values))
  end

  def prepare_array(any_array)
    any_array.uniq!
    array = merge_sort(any_array)
  end

end

my_tree = Tree.new([1,3,2])
p my_tree.root
