
def randomizedlist(size)
  list  = []
  rlist = []

  (1..size).each do |i|
    list.push(i)
  end

  while list.size > 0
    pivot = rand(list.size)
    rlist.push(list[pivot])
    list.delete(list[pivot])
  end
  return list
end


def randomizedlist_swap(size)
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

