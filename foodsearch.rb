#!/usr/bin/env ruby
#
# foodsearch.rb
# -------------
# this file calls the yahoo boss search api
# http://developer.yahoo.com/search/boss/boss_guide/
#
# usage: foodsearch.rb <search terms>
# e.g.:  ./foodsearch.rb chowder san francisco
#
#

require 'rubygems'
require 'net/http'
require 'uri'
require 'cgi'
require 'rexml/document'
require 'optparse'

API_KEY_FILE = '/Users/Jim/apikeys/yahoo_boss.txt'

#
#
# this is the base Bossurl class
#
#
class Bossurl
  attr_accessor :base, :app_id, :query, :sent
  def initialize(query)
    File.open(API_KEY_FILE, 'r') do |aFile|
      aFile.each_line { |line| @@app_id = line.chomp }
    end

    # if there are spaces in query then pre-pend and append double quotes
    query  = CGI.escape(query)
    query  = query.sub(/^/, '%22') if query =~ /[+]/
    query  = query.sub(/$/, '%22') if query =~ /[+]/
    @query = query
    @sent = @query + "?appid=" + CGI.escape(@@app_id) + "&count=3&format=xml&filter=-porn"
  end
end

#
# class: Bossweb
# --------------
# we're just doing a web search here. later we'll add
# Bossnews and Bossimage classes
#
class Bossweb < Bossurl
  def results
    @sent = "http://boss.yahooapis.com/ysearch/web/v1/" + @sent
    xml_data = Net::HTTP.get_response(URI.parse(@sent)).body
    # puts xml_data
    puts
    puts "--- results ---"
    doc = REXML::Document.new(xml_data)
    titles = []
    links  = []
    click  = []
		doc.elements.each('ysearchresponse/resultset_web/result/title') do |ele|
		   titles << ele.text
		end
		doc.elements.each('ysearchresponse/resultset_web/result/url') do |ele|
		   links << ele.text
		end
		doc.elements.each('ysearchresponse/resultset_web/result/clickurl') do |ele|
		   click << ele.text
		end

    titles.each_with_index do |title, idx|
      print "#{title} => #{links[idx]}\n"
    end
  end
end

def output_version
  puts 'foodsearch.rb -- version 0.2'
end

query = ARGV.join(" ")
puts "Searching for " + query + "..."

# let's get results from yelp
Bossweb.new("site:yelp.com #{query}").results 

# let's get results from anywhere
Bossweb.new("#{query}").results

