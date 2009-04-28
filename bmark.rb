#!/usr/bin/env ruby

require 'lib_misc'

print "randomlizedlist: "
a = Time.now.to_f
rlist = randomizedlist(4000)
b = Time.now.to_f
p(b - a)
print "\n"
print "\n"



print "randomlizedlist_old: "
a = Time.now.to_f
rlist = randomizedlist_swap(4000)
b = Time.now.to_f
p(b - a)
print "\n"


