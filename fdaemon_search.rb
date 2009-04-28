#!/usr/bin/env ruby

# sudo /usr/local/bin/nmap -sS -n -p 79 192.168.0.106 -P0
# /Users/barce/ruby/ruby/lib -- gearman lib

$: << '/Users/barce/ruby/ruby/lib'
require 'gearman'
require 'optparse'

Gearman::Util.debug = true

def scan_host ( ip )

  puts "scanning " + ip.to_s
  results = %x[/usr/local/bin/nmap -sS -n -p 79 #{ip} -P0]

  stuff = results.scan(/(open)/)
  if stuff.to_s == 'open'
    add_ip( ip )
  else
    puts "IP #{ip} is closed"
  end
end

class Simpletask
  attr_accessor :remotetask, :servers, :input, :result

  def initialize(remotetask)
    @remotetask = remotetask
    @servers    = '192.168.0.108:7003,192.168.0.106:7003'
  end

  def sendrequest
	  client = Gearman::Client.new(servers.split(','))
	  taskset = Gearman::TaskSet.new(client)
	  arg = [@input].join("\0")
	  task = Gearman::Task.new(@remotetask.to_s, arg, { :retry_count => 5} )
	  task.on_complete {|d| @result = d}
	  taskset.add_task(task)
	  taskset.wait(10)
  end
end

def check_ip ( ip )
  servers = '192.168.0.108:7003,192.168.0.106:7003'
  client = Gearman::Client.new(servers.split(','))
  taskset = Gearman::TaskSet.new(client)
  arg = [ip].join("\0")
  task = Gearman::Task.new('ispr', arg)
  task.on_complete {|d| puts d}
  taskset.add_task(task)
  taskset.wait(10)
end 

def add_ip ( ip )
  servers = '192.168.0.108:7003,192.168.0.106:7003'
  result = check_ip( ip )
  puts "result : #{result}"
  if result == true
    return "ip #{ip} is private\n"
  end
  client = Gearman::Client.new(servers.split(','))
  taskset = Gearman::TaskSet.new(client)
  arg = [ip].join("\0")
  # puts arg
  task = Gearman::Task.new('add_host', arg)
  task.on_complete {|d| puts d}
  taskset.add_task(task)
  taskset.wait(10)
end

# scan_host('192.168.0.106')
# scan_host(ip)

int2ip = Simpletask.new('toip')
puts int2ip.remotetask
int2ip.input = 555555
int2ip.sendrequest
puts int2ip.result
 
ip2int = Simpletask.new('toint')
puts ip2int.remotetask
ip2int.input = '12.0.0.0'
ip2int.sendrequest
puts ip2int.result
 
ip2int.input = '12.255.255.255'
ip2int.sendrequest
puts ip2int.result

myfile = ARGV[0]
myfile.chomp
listfile = File.open(myfile, 'r')
count = 1
listfile.each { |line| 
  puts "line " + count.to_s + " of #{myfile}"
  stringdate = %x[date]
  puts stringdate
  int2ip.input = line.chomp  
  int2ip.sendrequest
  puts int2ip.result
  scan_host(int2ip.result)
  count = count + 1
}

