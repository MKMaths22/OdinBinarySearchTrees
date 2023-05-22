# frozen_string_literal: true

module DriverScript

  def driver_script
    rand_array = Array.new(15) { rand(1..100) }
    tree = Tree.new(rand_array)
    puts "At step 2 we confirm tree is balanced by outputting #{tree.balanced?}"
    puts "Elements in level order done iteratively: #{tree.level_order}"
    puts "Elements in pre order: #{tree.preorder}"
    puts "Elements in post order: #{tree.postorder}"
    puts "Elements in order: #{tree.inorder}"
    tree.insert(200)
    tree.insert(300)
    tree.insert(400)
    tree.insert(500)
    puts "At step 5 we confirm the tree is unbalanced by outputting #{tree.balanced?}"
    tree.rebalance
    puts "At step 7 we confirm the tree is balanced by outputting #{tree.balanced?}"
    puts "Elements in level order done recursively: #{tree.level_order_rec}"
    puts "Elements in pre order: #{tree.preorder}"
    puts "Elements in post order: #{tree.postorder}"
    puts "Elements in order: #{tree.inorder}"
  end
end