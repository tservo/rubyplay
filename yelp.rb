#!/usr/bin/env ruby
#
# yelp.rb
# -------------
# date: 09/19/2008
# by:   barce[a t]codebelay.com
# this file calls the yelp search api
#
# usage: yelp.rb <search terms>
# e.g.:  ./yelp.rb chowder 
#
#

require 'rubygems'
require 'net/http'
require 'uri'
require 'cgi'
require 'optparse'
require 'json'


API_KEY_FILE = '/Users/barce/apikeys/yelp_YWSID.txt'

#
#
# this is the base Yelp class
#
#
class Yelp
  attr_accessor :base, :app_id, :query, :sent, :rawquery
  def initialize(query)
    File.open(API_KEY_FILE, 'r') do |aFile|
      aFile.each_line { |line| @@app_id = line.chomp }
    end

    @rawquery = query
    # if there are spaces in query then pre-pend and append double quotes
    query  = CGI.escape(query)
    query  = query.sub(/^/, '%22') if query =~ /[+]/
    query  = query.sub(/$/, '%22') if query =~ /[+]/
    @query = query
    @sent = "&ywsid=" + CGI.escape(@@app_id) 
  end
end

#
# class: Cityyelp
# --------------
# we're just doing a yelp city search here. 
#
class Cityyelp < Yelp
  def results
    @sent = "http://api.yelp.com/business_review_search?term=" + @query + "&location=" + CGI.escape("San Francisco, CA") + @sent
    puts @sent
    json_data = Net::HTTP.get_response(URI.parse(@sent)).body
    # puts xml_data
    puts
    result = JSON.parse(json_data)
    result.each { |key, value| 
      if key == 'businesses'
        value.each { |business|
          if business["name"] =~ /#{@rawquery}/i
            puts "-----[" + business["name"] + "]-----"
            puts business["address1"]
            puts business["address2"]
            puts business["mobile_url"]
            puts business["url"]
            puts 
          end
        }
      end 
    }
  end
end

query = ARGV.join(" ")
puts "Searching for " + query + "..."

# let's get results from yelp
Cityyelp.new("#{query}").results 

