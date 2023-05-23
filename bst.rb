# frozen_string_literal: true

require_relative 'driver_script'
require_relative 'merge_sort'

include DriverScript

# Node class describes methods for nodes of a binary search tree
class Node
  attr_accessor :left, :right, :value

  include Comparable

  def initialize(value, left = nil, right = nil)
    @value = value
    @left = left
    @right = right
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
  # See README for comments on pretty_print, which I did NOT write myself.

  def next_inorder(node)
    # this method returns the next node in order from a given node, with its parent
    # for use in the recursive delete method. We only need this method for nodes
    # that have two children
    return 'Error, must supply node with right child' unless node.right

    parent = node
    next_node = node.right
    while next_node.left
      parent = next_node
      next_node = next_node.left
      # we go as far left as possible from the right child
    end
    [next_node, parent]
  end

  def height(node)
    return -1 unless node

    # nil has height -1, so that leaf nodes have height 0
    1 + [height(node.left), height(node.right)].max
  end

  def depth(target, node = @root, depth_so_far = 0)
    return depth_so_far if target == node
    return depth(target, node.left, depth_so_far + 1) if target.value < node.value

    depth(target, node.right, depth_so_far + 1)
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
    return nil if array.empty?

    mid_index = array.size / 2
    mid_value = array[mid_index]
    left_values = array.slice!(0, mid_index)
    array.shift
    # shift removes the middle value of the original array here
    right_values = array
    # we modified array in place so right_values is what remains
    Node.new(mid_value, build_tree(left_values), build_tree(right_values))
  end

  def prepare_array(any_array)
    any_array.uniq!
    merge_sort(any_array)
  end

  def find(value, find_parent = false, node = @root, parent_node = nil)
    # optional argument find_parent can be supplied as true and the method
    # outputs the node and its parent in an array
    return nil unless node

    return [node, parent_node] if node.value == value && find_parent

    return node if node.value == value

    return find(value, find_parent, node.right, node) if node.value < value

    find(value, find_parent, node.left, node)
  end

  def insert(value, node = @root)
    # optional node argument keeps track of recursive progress towards where we insert
    added_node = Node.new(value)
    unless node
      @root = added_node
      return
    end
    # if tree were empty, the added_node will be the root
    if value == node.value
      puts 'Duplication error, requested value already in tree.'
      return
    end

    if value > node.value
      node.right ? insert(value, node.right) : node.right = added_node
    end
    return unless value < node.value

    node.left ? insert(value, node.left) : node.left = added_node

    # we recursively look lower down tree for insertion point unless there is no child in the direction we are looking
  end

  def delete(value)
    found_nodes = find(value, true)
    # find method supplies node and its parent as an array
    node = found_nodes[0]
    return unless node

    # guard clause in case value not found
    delete_node(found_nodes)
  end

  def delete_node(node_parent_array)
    node, parent = node_parent_array

    unless node.left && node.right
      child = node.left || node.right
      # child is the one child of node, or nil if it is a leaf
      if @root == node
        @root = child
        return node
      end

      # if node is not the root, parent must have link changed

      parent.left == node ? parent.left = child : parent.right = child
      return node
    end

    # now node has two children for sure, we copy contents from inorder successor
    # and recursively delete the inorder successor
    successor_and_parent = node.next_inorder(node)
    # which returns array of the next inorder node and its parent, allowing us
    # to call delete_node recursively
    successor = successor_and_parent[0]
    node.value = successor.value
    delete_node(successor_and_parent)
  end

  def level_order
    array_queue = [@root]
    output_array = []
    # stores nodes to visit in BFS order. We push nodes on at the back and shift off at the front
    while array_queue[0]
      node = array_queue.shift
      block_given? ? yield(node) : output_array.push(node.value)
      array_queue.push(node.left) if node.left
      array_queue.push(node.right) if node.right
    end
    return output_array unless block_given?
  end

  def level_order_rec(node_array = [@root], values_array = [], &block)
    unless node_array[0]
      return values_array unless block_given?

      return
    end

    node = node_array.shift
    block_given? ? yield(node) : values_array.push(node.value)
    node_array.push(node.left) if node.left
    node_array.push(node.right) if node.right

    level_order_rec(node_array, values_array, &block)
  end

  def many_orders(order, node = @root, array = [], &block)
    return unless node

    block_given? ? yield(node) : array.push(node.value) if order == 'pre'
    many_orders(order, node.left, array, &block)
    block_given? ? yield(node) : array.push(node.value) if order == 'in'
    many_orders(order, node.right, array, &block)
    block_given? ? yield(node) : array.push(node.value) if order == 'post'

    return array unless block_given?
  end

  def inorder(node = @root, array = [], &block)
    many_orders('in', node = @root, array = [], &block)
  end

  def preorder(node = @root, array = [],&block)
    many_orders('pre', node = @root, array = [], &block)
  end

  def postorder(node = @root, array = [],&block)
    many_orders('post', node = @root, array = [], &block)
  end

  def balanced?(node = @root)
    # calculates height of nodes and whether their subtree is balanced recursively
    return true unless @root
    # empty tree is balanced

    return [-1, true] unless node

    # nil has height -1 and its subtree is balanced, base case of recursion

    temp = balanced?(node.left).concat(balanced?(node.right))
    # temp array looks like (height_left, true/false, height_right, true/false)
    height = [temp[0], temp[2]].max + 1
    boolean = temp[1] && temp[3] && (temp[0] - temp[2]).between?(-1, 1)
    # tree balanced if both subtrees balanced and their heights differ by -1, 0 or 1
    return boolean if node == @root

    # outermost function returns only the boolean value, otherwise height returned as well
    [height, boolean]
  end

  def rebalance
    # method assumes we know tree is not balanced to prevent duplicating code
    @root = build_tree(inorder)
  end
end

driver_script