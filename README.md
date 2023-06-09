# OdinBinarySearchTrees
Follows TOP Binary Search Trees assignment.

This project uses the MIT License.

Project instructions:
-----------------------------------

(1) Build a Node class. It should have an attribute for the data it stores as well as its left and right children. As a bonus, try including the Comparable module and compare nodes using their data attribute.

(2) Build a Tree class which accepts an array when initialized. The Tree class should have a root attribute which uses the return value of #build_tree which you’ll write next.

(3) Write a #build_tree method which takes an array of data (e.g. [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]) and turns it into a balanced binary tree full of Node objects appropriately placed (don’t forget to sort and remove duplicates!). The #build_tree method should return the level-0 root node.

(4) Write an #insert and #delete method which accepts a value to insert/delete (you’ll have to deal with several cases for delete such as when a node has children or not).  

You may be tempted to implement these methods using the original input array, but it’s important for the efficiency of these operations that you don’t do this. Binary search trees can insert/delete in O(log n) time, which is a significant performance boost over arrays for the same operations. In order to get this added efficiency, your implementation of these methods should traverse the tree and manipulate the nodes and their connections.

(5) Write a #find method which accepts a value and returns the node with the given value.

(6) Write a #level_order method which accepts a block. This method should traverse the tree in breadth-first level order and yield each node to the provided block. This method can be implemented using either iteration or recursion (try implementing both!). The method should return an array of values if no block is given. Tip: You will want to use an array acting as a queue to keep track of all the child nodes that you have yet to traverse and to add new ones to the list.

(7) Write #inorder, #preorder, and #postorder methods that accepts a block. Each method should traverse the tree in their respective depth-first order and yield each node to the provided block. The methods should return an array of values if no block is given.

(8) Write a #height method which accepts a node and returns its height. Height is defined as the number of edges in longest path from a given node to a leaf node.

(9) Write a #depth method which accepts a node and returns its depth. Depth is defined as the number of edges in path from a given node to the tree’s root node.

(10) Write a #balanced? method which checks if the tree is balanced. A balanced tree is one where the difference between heights of left subtree and right subtree of every node is not more than 1.

(11) Write a #rebalance method which rebalances an unbalanced tree. Tip: You’ll want to use a traversal method to provide a new array to the #build_tree method.

Tie it all together.  
Write a simple driver script that does the following:

(1) Create a binary search tree from an array of random numbers (Array.new(15) { rand(1..100) })  
(2) Confirm that the tree is balanced by calling #balanced?  
(3) Print out all elements in level, pre, post, and in order  
(4) Unbalance the tree by adding several numbers > 100  
(5) Confirm that the tree is unbalanced by calling #balanced?  
(6) Balance the tree by calling #rebalance  
(7) Confirm that the tree is balanced by calling #balanced?  
(8) Print out all elements in level, pre, post, and in order  

-------------------------------
Comments from the author, Peter Hawes:
-------------------------------

As suggested by The Odin Project, I used the pretty_print method that a previous student had shared on Discord. What a pity I can't credit them personally. It was extremely useful to visualise the trees as I tested the many methods. Thanks, whoever you are!!

It was also helpful to use my merge_sort method by importing the module MergeSort from merge_sort.rb for use in #build_tree.  

I have implemented both recursive and iterative versions of #level_order: #level_order and #level_order_rec.  
I was using left_child and right_child for the children of nodes but changed it at the end to left and right to make the code more readable.
