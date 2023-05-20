# frozen_string_literal: true

require_relative 'merge_sort'

class Node

  attr_accessor :left_child, :right_child, :value
  
  include Comparable

  def initialize(value, left_child = nil, right_child = nil)
    @value = value
    @left_child = left_child
    @right_child = right_child
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
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

  def find(value, node = @root)
    return nil unless node
    
    return node if node.value == value
    return find(value, node.right_child) if node.value < value
    return find(value, node.left_child)
  end 

  def insert(value, node = @root)
    added_node = Node.new(value)
    return unless node
    node.right_child ? insert(value, node.right_child) : node.right_child = added_node if value > node.value
    node.left_child ? insert(value, node.left_child) : node.left_child = added_node if value < node.value    
  end



end

my_tree = Tree.new([3,4,5,6])
# p my_tree.root
my_tree.root.pretty_print(my_tree.root)
my_tree.insert(4.5)
my_tree.root.pretty_print(my_tree.root)
my_tree.insert(3.5)
my_tree.root.pretty_print(my_tree.root)
