# coding: utf-8

module LibProxy
  module PluggableTransport
    module Obfs4proxy
      def loadObfs4Config()
        # Two different request header for obfs4 forward server.
        # tenco.info
        obfs4_REQUEST_HEADER_MAIN = {"Host" => "#{$SERVER_ACCOUNT_HOST}"}
        http_REQUEST_HEADER_MAIN = $HTTP_REQUEST_HEADER_MAIN
        $HTTP_REQUEST_HEADER_MAIN = http_REQUEST_HEADER_MAIN.merge(obfs4_REQUEST_HEADER_MAIN)
        # static.tenco.info
        obfs4_REQUEST_HEADER_STATIC = {"Host" => "#{$CLIENT_LATEST_VERSION_HOST}"}
        http_REQUEST_HEADER_STATIC = $HTTP_REQUEST_HEADER_STATIC
        $HTTP_REQUEST_HEADER_STATIC = http_REQUEST_HEADER_STATIC.merge(obfs4_REQUEST_HEADER_STATIC)
        # SERVER_TRACK_RECORD
        $SERVER_TRACK_RECORD_HOST = $env['server_obfs4']['track_record']['host'].to_s
        $SERVER_TRACK_RECORD_ADDRESS = $env['server_obfs4']['track_record']['address'].to_s
        $SERVER_TRACK_RECORD_PORT = $env['server_obfs4']['track_record']['port'].to_s
        $SERVER_TRACK_RECORD_PATH = $env['server_obfs4']['track_record']['path'].to_s
        $SERVER_TRACK_RECORD_HEADER = $HTTP_REQUEST_HEADER_MAIN
        # SERVER_LAST_TRACK_RECORD
        $SERVER_LAST_TRACK_RECORD_HOST = $env['server_obfs4']['last_track_record']['host'].to_s
        $SERVER_LAST_TRACK_RECORD_ADDRESS = $env['server_obfs4']['last_track_record']['address'].to_s
        $SERVER_LAST_TRACK_RECORD_PORT = $env['server_obfs4']['last_track_record']['port'].to_s
        $SERVER_LAST_TRACK_RECORD_PATH = $env['server_obfs4']['last_track_record']['path'].to_s
        $SERVER_LAST_TRACK_RECORD_HEADER = $HTTP_REQUEST_HEADER_MAIN
        # SERVER_ACCOUNT
        $SERVER_ACCOUNT_HOST = $env['server_obfs4']['account']['host'].to_s
        $SERVER_ACCOUNT_ADDRESS = $env['server_obfs4']['account']['address'].to_s
        $SERVER_ACCOUNT_PORT = $env['server_obfs4']['account']['port'].to_s
        $SERVER_ACCOUNT_PATH = $env['server_obfs4']['account']['path'].to_s
        $SERVER_ACCOUNT_HEADER = $HTTP_REQUEST_HEADER_MAIN
        # CLIENT_LATEST_VERSION
        $CLIENT_LATEST_VERSION_HOST = $env['client_obfs4']['latest_version']['host'].to_s
        $CLIENT_LATEST_VERSION_ADDRESS = $env['client_obfs4']['latest_version']['address'].to_s
        $CLIENT_LATEST_VERSION_PORT = $env['client_obfs4']['latest_version']['port'].to_s
        $CLIENT_LATEST_VERSION_PATH = $env['client_obfs4']['latest_version']['path'].to_s
        $CLIENT_LATEST_VERSION_HEADER = $HTTP_REQUEST_HEADER_STATIC
        # CLIENT_SITE_URL
        $CLIENT_SITE_URL = "http://#{$env['client_obfs4']['site']['host']}#{$env['client_obfs4']['site']['path']}"
      end
      def ManageObfs4proxyProcess(action)
        obfs4Cmd = nil
        if action == 'start'
          obfs4Cmd = $variables['OBFS4_PROXY_START_BIN']
        elsif action == 'exit'
          obfs4Cmd = $variables['OBFS4_PROXY_EXIT_BIN']
        end

        stdin, stdout, stderr = popen3(obfs4Cmd)
      end
      def detectObfs4proxyStatus()
        strings = $stringYaml['obfs4_string']
        puts strings['obfs4proxy_loading']

        obfs4Env = $env['server_obfs4']['account']
        obfs4ListendOn = "#{obfs4Env['address']}:#{obfs4Env['port']}"

        unless $variables['OBFS4_TCPPING_EULA_STATUS']
          puts strings['please_accept_tcpping_eula']
          puts
          eulaCmd = $variables['OBFS4_TCPPING_BIN_EULA']
          stdin, stdout, stderr = popen3(eulaCmd)
          eulaContents = stdout.read
          eulaResult = stderr.read
          puts eulaContents
          # Make sure tcpping exist.
          if eulaResult.include? eulaCmd
            puts strings['tcpping_missing']
            exit
          else
            puts strings['press_enter_key']
            gets
            $variables['OBFS4_TCPPING_EULA_STATUS'] = true
            saveConfigFile()
          end
        end

        # Detect obfs4proxy process
        tcpPingDone = false
        tcpPingRetryTimes = 0
        while tcpPingDone == false
          tcpPingCmd = "#{$variables['OBFS4_TCPPING_BIN'] % [obfs4ListendOn]}"
          ###
          # Ping and get output
          stdin, stdout, stderr = popen3(tcpPingCmd)
          # If return nothing error, that means obfs4 proxy is running.
          if stderr.read.strip.empty?
            tcpPingDone = true
            $obfs4_ready = true
            # Wait until obfs4proxy fully loaded
            # On some slow devices, even if tcpping responed, connection can't create
            # 3 seconds should be fine, but moving it into config
            sleep $variables['OBFS4_PROXY_WAIT_LOAD']
            puts strings['obfs4proxy_working']
          else
            if tcpPingRetryTimes > $variables['OBFS4_TCPPING_RETRY_IGNORE_OUTPUT_TIMES']
              puts strings['obfs4proxy_timeout']
            end

            tcpPingRetryTimes = tcpPingRetryTimes + 1
            if tcpPingRetryTimes == $variables['OBFS4_TCPPING_RETRY_TIMES']
              puts strings['obfs4proxy_unavailable']
              puts
              $is_warning_exist = true
              DoExitActions()
            end
          end
        end
        puts
      end
    end
  end
end
