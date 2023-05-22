# frozen_string_literal: true

require_relative 'driver_script'
require_relative 'merge_sort'

include DriverScript

# Node class describes methods for nodes of a binary search tree
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

  def next_inorder(node)
    return 'Error, must supply node with right child' unless node.right_child
    parent = node
    next_node = node.right_child
    while next_node.left_child do
      parent = next_node
      next_node = next_node.left_child 
    # we go as far left as possible from the right child
    end
    [next_node, parent]
  end

  def height(node)
    return -1 unless node
    # nil has height -1, so that leaf nodes have height 0
    return 1 + [height(node.left_child), height(node.right_child)].max
  end

  def depth(target, node = @root, depth_so_far = 0)
    return depth_so_far if target == node
    return depth(target, node.left_child, depth_so_far + 1) if target.value < node.value
    return depth(target, node.right_child, depth_so_far + 1)
  end
end

# Tree class is for the binary search trees themselves
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

  def find(value, find_parent = false, node = @root, parent_node = nil)
    # optional argument find_parent can be supplied as true and the method
    # outputs the node and its parent in an array
    return nil unless node
    
    return [node, parent_node] if node.value == value && find_parent
    return node if node.value == value
    return find(value, find_parent, node.right_child, node) if node.value < value
    return find(value, find_parent, node.left_child, node)
  end 

  def insert(value, node = @root)
    added_node = Node.new(value)
    @root = added_node unless node
    return unless node 
    
    node.right_child ? insert(value, node.right_child) : node.right_child = added_node if value > node.value
    node.left_child ? insert(value, node.left_child) : node.left_child = added_node if value < node.value    
  end

  def delete(value)
    found_nodes = find(value, 'parent')
    # find method supplies node and its parent as an array
    node = found_nodes[0]
    return unless node
    # guard clause in case value not found
    
    parent = found_nodes[1]

    delete_node(node, parent)
  end
    
  def delete_node(node, parent)
  
    if !node.left_child && !node.right_child
    # node is a leaf, just remove connection from parent
      if @root == node
        @root = nil
        return node
      end
      # if node is not the root, it has a parent which must have link changed
      parent.left_child = nil if parent.left_child == node
      parent.right_child = nil if parent.right_child == node
      return node
    end

    if !node.left_child 
    # already covered case of no children at all, so there will be a right_child
    # parent gets connected to the child instead of the node we are deleting
      if @root == node
        @root = node.right_child
        return node
      end 
      # if node is not the root, it has a parent which must have link changed
      parent.left_child = node.right_child if parent.left_child == node
      parent.right_child = node.right_child if parent.right_child == node
      return node
    end

    if !node.right_child
    # just like above, but with left and right reversed. Refactor later for DRY
      if @root == node
        @root = node.left_child
        return node
      end
    # if node is not the root, it has a parent which must have link changed
      parent.left_child = node.left_child if parent.left_child == node
      parent.right_child = node.left_child if parent.right_child == node
      return node
    end

    # now node has two children for sure, we copy contents from inorder successor
    # and recursively delete the inorder successor

    successor_and_parent = node.next_inorder(node)
    # which returns array of the next inorder node and its parent, allowing us
    # to call delete_node recursively
    successor = successor_and_parent[0]
    node.value = successor.value
    new_parent = successor_and_parent[1]
    delete_node(successor, new_parent)
  end

  def level_order
    array_queue = [@root] if @root
    output_array = []
    # stores nodes to visit in BFS order. We push nodes on at the back and shift off at the front
    while array_queue[0] do
      node = array_queue.shift
      block_given? ? yield(node) : output_array.push(node.value)
      array_queue.push(node.left_child) if node.left_child
      array_queue.push(node.right_child) if node.right_child
    end
    return output_array unless block_given? 
  end

  def inorder(node = @root, array = [],&block)
    return unless node
    
    inorder(node.left_child, array, &block)
    block_given? ? yield(node) : array.push(node.value)
    inorder(node.right_child, array, &block)
    return array if node == @root && !block_given?
  end

  def preorder(node = @root, array = [],&block)
    return unless node

    block_given? ? yield(node) : array.push(node.value)
    preorder(node.left_child, array, &block)
    preorder(node.right_child, array, &block)
    return array if node == @root && !block_given?
  end

  def postorder(node = @root, array = [],&block)
    return unless node

    postorder(node.left_child, array, &block)
    postorder(node.right_child, array, &block)
    block_given? ? yield(node) : array.push(node.value)
    return array if node == @root && !block_given?
  end

  def balanced?(node = @root)
    # calculates height of nodes and whether their subtree is balanced recursively
    return true unless @root
    # empty tree is balanced
    
    return [-1, true] unless node
    # nil has height -1 and its subtree is balanced, base case of recursion
    
    temp = balanced?(node.left_child).concat(balanced?(node.right_child))
    # temp array looks like (height_left, true/false, height_right, true/false)
    height = [temp[0], temp[2]].max + 1
    boolean = temp[1] && temp[3] && (temp[0] - temp[2]).between?(-1,1)
    return boolean if node == @root 
    return [height, boolean]
  end

  def rebalance
    # method assumes we know tree is not balanced to prevent duplicating code
    @root = build_tree(inorder)
  end

end

driver_script
