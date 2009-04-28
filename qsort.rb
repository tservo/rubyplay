#!/usr/local/bin/ruby

# qsort.rb
# ------------
# a ruby implementation of quicksort
# author: barce
# date:   Sunday, 4/12/2008, 1941 PDT
#
# http://en.wikipedia.org/wiki/Quicksort
#

def qsort(list)


  # because a list of one or less is sorted
  if (list.size <= 1) 
    return list
  end

  # get the mid point so that we can split the list
  pivot = list.size / 2

  # anything less than pivot goes into less
  # anything more than pivot goes into more
  less = []
  more = []

	# swap pivot
  tmp = list[0]
  list[0] = list[pivot]
  list[pivot] = tmp

  # loop through list[1] to list[max]
  (1..list.size).each do |i|
    unless list[i].nil?
      if list[i] < list[0]
        less.push(list[i]) 
      else 
        more.push(list[i]) 
      end
    end
  end

  # concatenate  less + pivot + more

  return qsort(less) + [list[0]] + qsort(more)
end

def randomizedlist(size)
  list       = []
  randomlist = []
  (1..size).each do |i|
    list.push(i)
  end

  while list.size > 0
    pivot       = rand(list.size)
    tmp         = list[0]
    list[0]     = list[pivot] 
    list[pivot] = tmp
    out         = list.shift
    randomlist.push(out) 
  end
  return randomlist
end


rlist = randomizedlist(40000)
# rlist.each { |i| print i.to_s + " "  }

print "\n"
print "quick sort: \n";
# qsort(rlist).each { |i| print i.to_s + " " }
print "\n"
a = Time.now.to_f
qsort(rlist)
b = Time.now.to_f
print "\n"
p(b - a)

