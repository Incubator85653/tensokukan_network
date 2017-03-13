# coding: utf-8

require 'rubygems'
require 'nkf'
require 'net/http'
Net::HTTP.version_1_2

### Check updates ###

# puts "★クライアント最新バージョン自動チェック"
# puts 
module TskNet
  module UpdateCheck
    def get_latest_version_direct(latest_version_host, latest_version_path)
      response = nil
      Net::HTTP.new(latest_version_host, 80).start do |s|
        response = s.get(latest_version_path, $HTTP_REQUEST_HEADER)
      end  
      response.code == '200' ? response.body.strip : nil
    end
  end
end