# coding: utf-8

module LibTsk
  module Network
    def get_latest_version_direct()
      response = nil
      Net::HTTP.new($CLIENT_LATEST_VERSION_ADDRESS, $CLIENT_LATEST_VERSION_PORT).start do |s|
        response = s.get($CLIENT_LATEST_VERSION_PATH, $CLIENT_LATEST_VERSION_HEADER)
      end
      response.code == '200' ? response.body.strip : nil
    end
    def doUpdateCheck()
      begin
        latest_version = get_latest_version_direct()

        case
        when latest_version.nil?
          puts "！最新バージョンの取得に失敗しました。"
          puts "スキップして続行します。"
        when latest_version > $variables['PROGRAM_VERSION'] then
          puts "★新しいバージョンの#{$variables['PROGRAM_NAME']}が公開されています。（ver.#{latest_version}）"
          puts "ブラウザを開いて確認しますか？（Nを入力するとスキップ）"
          print "> "
          case gets[0..0]
          when "N" then
            puts "スキップして続行します。"
            puts
          else
            system "start #{$CLIENT_SITE_URL}"
            exit
          end
        when latest_version <= $variables['PROGRAM_VERSION'] then
          puts "お使いのバージョンは最新です。"
          puts
        end

      # Print a message if update check was failed
      rescue => ex
        puts "！クライアント最新バージョン自動チェック中にエラーが発生しました。"
        puts ex.to_s
        # puts ex.backtrace.join("\n")
        puts ex.class
        puts
        puts "スキップして処理を続行します。"
        puts
      end
    end
end
