#!/usr/local/bin/ruby

# mergesort.rb
# ------------
# a ruby implementation of mergesort
# author: barce
# date:   Saturday, 11/15/2008, 0033 PST
#
# http://en.wikipedia.org/wiki/Mergesort
#

def mergesort(list)

	# because a list of one is sorted
	if (list.size <= 1) 
		return list
	end

	# get the mid point so that we can split the list
	middle = list.size / 2

	# fill in the left list
	left = []
	middle.times do |i| 
		left.push(list[i])
	end

	# fill in the right list
	right = []
	(middle..list.size).each do |i|
		right.push(list[i]) unless list[i].nil?
	end

	left = mergesort(left)
	right = mergesort(right)
	return merge(left, right)
end

def merge(left, right)

	result = []

	# while there's something in the two arrays
	# let's do the following:
	# compare the 1st element of each array.
	# the smaller goes into the result array
	# how do I make the while block more ruby...
	while ((left.size > 0) && (right.size > 0))

		if left[0] <= right[0]
			result.push(left[0])
			left.shift
    end

    if left[0] > right[0]
			result.push(right[0])
			right.shift
		end

	end

	if left.size > 0
		left.each { |i| result.push(i) }
	end

	if right.size > 0
		right.each { |i| result.push(i) }
	end

	return result
end

list = [3, 7, 10, 12, 100, 8]

list = mergesort(list)
puts "list:"
list.each {|i| puts i}

