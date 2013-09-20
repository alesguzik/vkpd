module Vkpd
  class CLI
    # main CLI method
    def main
      mpd = MPD.new 'localhost'
      mpd.connect
      method = "audio.search"
      params = {}
      do_clear = true
      do_play = true
      params["auto_complete"] = '1'
  
      if ARGV.empty?
        ARGV.push "-h"
      end
  
      while ARGV.size > 0
        current = ARGV.shift
        case current
        when '-h','--help'
          filename = Pathname(__FILE__).dirname+'../../README'
          puts File.read(filename)
          exit 0
        when '-d', '--debug'
          @debug  = true
        when '-c', '--count', /^--count=\d+$/
          value = current.include?("=") ? current.match(/=(.*)/)[1] : ARGV.shift
          params["count"]  = value
        when '-o', '--offset', /^--offset=\d+$/
          value = current.include?("=") ? current.match(/=(.*)/)[1] : ARGV.shift
          params["offset"] = value
        when '-s', '--sort', /^--sort=\d+$/
          value = current.include?("=") ? current.match(/=(.*)/)[1] : ARGV.shift
          params["sort"] = value
        when 'user'
          method = 'audio.get'
          if !ARGV.empty? and ARGV.first.match(/^\d+$/)
            params['uid'] = ARGV.shift
          else
            params['uid'] = Vkpd::config["user_id"]
          end
        when 'group'
          method = 'audio.get'
          params['gid'] = ARGV.shift
        when 'add'
          do_clear = false
          do_play = false
        when '-nf','--no-fix', '--exact'
          params["auto_complete"] = '0'
        when '--https'
          params['https'] = '1'
        when 'auth'
          Thread.new do
            sleep 1
            Launchy.open('http://localhost.localdomain:4567')
          end
          Vkpd::Auth.run!
        when 'play'
          # do nothing
        else
          params["q"]=ARGV.unshift(current).join(" ")
          ARGV.clear
        end
      end
  
  
      params["access_token"]=Vkpd::config["access_token"]
      
      connection=Net::HTTP.new("api.vk.com",443)
      connection.use_ssl=true
      data=connection.get("/method/#{method}?#{hash_to_params(params)}").body
      response = JSON.parse(data)["response"]
      if method.match /search/
        response.shift
      end
      mpd.clear if do_clear
      response.each do |song|
        puts song if @debug
        mpd.add song["url"]
      end
      mpd.play if do_play
    end

    private
  
    # Makes string with params for http request from hash
    def hash_to_params(hash)
      hash.map{|k,v| "#{k}=#{CGI.escape(v.to_s)}"}.join("&")
    end

  end
end
