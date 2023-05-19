# frozen_string_literal: true

# MergeSort module includes merge_sort method for merge sorting an array
module MergeSort
  def merge(left, right)
    output = []
    left.push(right[-1] + 1)
    right.push(left[-2] + 1)
    # Adds large dummy values, higher than highest (rightmost element) in the OTHER
    # array, to each array. This means that as we choose and remove elements from the
    # left and right arrays neither becomes empty, which would cause a 'comparison with # nil' error
    until left.size + right.size == 2
      output.push(left.shift) if left[0] < right[0]
      output.push(right.shift) if left[0] >= right[0]
    end
    output
  end

  def merge_sort(array)
    size = array.size
    return array if size <= 1

    left_array = array.slice!(0, size / 2)
    right_array = array
    merge(merge_sort(left_array), merge_sort(right_array))
  end
end

include MergeSort

# p shuffled_array = (1..30).to_a.shuffle()
# returns the numbers 1 to 30, shuffled randomly
# p merge_sort(shuffled_array) returns the numbers in increasing order.
