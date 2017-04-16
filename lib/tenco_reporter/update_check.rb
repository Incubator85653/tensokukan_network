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
    def get_latest_version_direct()
      response = nil
      Net::HTTP.new($CLIENT_LATEST_VERSION_ADDRESS, $CLIENT_LATEST_VERSION_PORT).start do |s|
        response = s.get($CLIENT_LATEST_VERSION_PATH, $CLIENT_LATEST_VERSION_HEADER)
      end  
      response.code == '200' ? response.body.strip : nil
    end
  end
end