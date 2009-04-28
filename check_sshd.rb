#!/usr/bin/env ruby


require 'date'
require 'yaml'
require 'net/http'
require 'uri'


# functions
def send_twitter (latest, settings)

  # http://twitter.com/direct_messages/new.format

  twitter_email     = settings['twitter_email']
  twitter_password  = settings['twitter_password']
  twitter_recipient = settings['twitter_recipient']
  repo_text         = settings['repo']

  update_text = "#{latest}"
  

begin
    url = URI.parse('http://twitter.com/direct_messages/new.xml')
    req = Net::HTTP::Post.new(url.path)
    req.basic_auth twitter_email, twitter_password
    req.set_form_data({'user' => twitter_recipient, 'text' => update_text})

    begin
        res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }

        case res
        when Net::HTTPSuccess, Net::HTTPRedirection
            if res.body.empty?
                # Twitter is not responding properly
            else
                # message sent
            end

        else
            # Twitter update failed for an unknown reason
            res.error!
        end

    rescue
        # Twitter update failed - check username/password
    end

rescue SocketError
    # Twitter is currently unavailable
end


end



yamlstring = ''
File.open("/home/git/bin/settings.yaml", "r") { |f|
    yamlstring = f.read
}

settings = YAML::load(yamlstring)
puts settings.inspect
puts settings["path"]


Dir.chdir(settings["path"])
i = 0
1000.times do
  results = %x[scp test.txt jim.barcelona@10.192.128.186:/cygdrive/c/inetpub/wwwroot/.]
  puts "----[ " + i.to_s + " ]----"
  # stuff = results.scan(/At revision ([0-9]+)/)
  puts results.to_s

  sleep settings["sleepseconds"].to_i

  i=i+1

  if results.scan(/lost/).length > 0 
    send_twitter("sshd nyc video proxy is down", settings)
    puts "lost connection"
    exit
  end
end
