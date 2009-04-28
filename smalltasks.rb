#!/usr/bin/env ruby

# sudo /usr/local/bin/nmap -sS -n -p 79 192.168.0.106 -P0
# /Users/barce/ruby/ruby/lib -- gearman lib

$: << '/Users/barce/ruby/ruby/lib'
require 'gearman'
require 'optparse'

Gearman::Util.debug = true

class Simpletask
  attr_accessor :remotetask, :servers, :input, :result

  def initialize(remotetask)
    @remotetask = remotetask
    @servers    = '99.204.175.116:7003'
  end

  def sendrequest
	  client = Gearman::Client.new(servers.split(','))
	  taskset = Gearman::TaskSet.new(client)
	  arg = [@input].join("\0")
	  task = Gearman::Task.new(@remotetask.to_s, arg)
	  task.on_complete {|d| @result = d}
	  taskset.add_task(task)
	  taskset.wait(10)
  end
end

task = ARGV[0]
input = ARGV[1]
input.chomp
task.chomp

fetcher = Simpletask.new(task)
puts fetcher.remotetask
fetcher.input = input
fetcher.sendrequest
puts fetcher.result
 

