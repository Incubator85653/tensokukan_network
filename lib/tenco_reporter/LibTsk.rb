# coding: utf-8

module LibTsk
  module Console
    def printWellcomeMessage()
      # Print program name and version and something else
      # at the very beginning
      puts $stringYaml['wellcome_message']['branch_name']
      puts
      puts "#{$stringYaml['wellcome_message']['str_api_version']} #{$variables['PROGRAM_VERSION']}"
      puts "#{$stringYaml['wellcome_message']['str_branch_version']} #{$stringYaml['wellcome_message']['branch_version']}"
      puts "#{$stringYaml['wellcome_message']['str_network_protocol']} #{$networkProtocol.upcase}"
      puts
    end
    def printHTTPcode(response)
      puts "HTTP #{response.code}"
      puts
    end
    def DoExitActions()
      strings = $stringYaml['exit_message']

      # Close obfs4proxy client
      if $networkProtocol.upcase == 'OBFS4'
        ManageObfs4proxyProcess('exit')
      end

      if $is_warning_exist then
        #puts "報告処理は正常に終了しましたが、警告メッセージがあります。"
        #puts "出力結果をご確認ください。"
        #puts
        #puts "Enter キーを押すと、処理を終了します。"
        puts strings['yes_error']

        gets
        exit
      else
        #puts "報告処理が正常に終了しました。"
        puts strings['no_error']
        puts
      end

      # Make a delay, allow user to check their record for few seconds
      delayTime = $variables['WAIT_SECONDS_BEFORE_EXIT']

      puts strings['wait_for_few_seconds'] % [delayTime]
      sleep delayTime
      exit
    end
  end
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
    def doAccountSignUp()
      strings = $stringYaml['do_account_signup']

      #puts "★新規 #{$variables['$WEB_SERVICE_NAME']} アカウント登録\n\n"
      puts strings['new_account_signup'] % [$WEB_SERVICE_NAME] + $NEW_LINE*2

      # While loop until successful signed up
      while (!$is_account_register_finish)
        #Enter account name

        #puts "希望アカウント名を入力してください\n"
        #puts "アカウント名はURLの一部として使用されます。\n"
        #puts "（半角英数とアンダースコア_のみ使用可能。32文字以内）\n"
        #print "希望アカウント名> "
        puts strings['signup_description']
        puts strings['account_name_rules']
        puts

        print strings['enter_account_name']
        print $stringYaml['input']

        while (input = gets)
          input.strip!
          if input =~ $ACCOUNT_NAME_REGEX then
            $account_name = input
            puts
            break
          else
            #puts "！希望アカウント名は半角英数とアンダースコア_のみで、32文字以内で入力してください"
            #print "希望アカウント名> "
            puts strings['account_name_rules']
            puts

            print strings['enter_account_name']
            print $stringYaml['input']
          end
        end
        puts strings['added_account'] % [$account_name]
        puts

        # Enter password

        #puts "パスワードを入力してください（使用文字制限なし。4～16byte以内。アカウント名と同一禁止。）\n"
        #print "パスワード> "
        puts strings['password_rules']
        puts

        print strings['enter_password']
        print $stringYaml['input']

        while (input = gets)
          input.strip!
          if (input.length >= 4 and input.length <= 16 and input != $account_name) then
            $account_password = input
            puts
            break
          else
            # If entered a password that same as account
            # Show a warn and retry
            if input == $account_name
              puts strings['pwd_same_as_account']
              puts
            end
            #puts "！パスワードは4～16byte以内で、アカウント名と別の文字列を入力してください"
            #print "パスワード> "
            puts strings['password_rules']
            puts

            print strings['enter_password']
            print $stringYaml['input']
          end
        end

        puts strings['added_password'] % [$account_password]
        puts
        print strings['confirm_password']
        print $stringYaml['input']

        while (input = gets)
          input.strip!
          if ($account_password == input) then
            puts
            puts strings['password_confirmed']
            puts
            break
          else
            puts strings['password_mismatch']
            puts

            print strings['confirm_password']
            print $stringYaml['input']
          end
        end

        # Enter email address

        #puts "メールアドレスを入力してください（入力は任意）\n"
        #puts "※パスワードを忘れたときの連絡用にのみ使用します。\n"
        #puts "※記入しない場合、パスワードの連絡はできません。\n"
        #print "メールアドレス> "

        puts strings['email_rules']
        puts

        print strings['enter_email']
        print $stringYaml['input']

        while (input = gets)
          input.strip!
          if (input == '') then
            account_mail_address = ''
            #puts "メールアドレスは登録しません。"
            puts
            puts strings['skip_email']
            puts strings['skip_email_disabled']
            puts

            print strings['enter_email']
            print $stringYaml['input']
            # Skip email in Tsk 2017 was disabled
            # Must assign an email address to sign up
            #break

          elsif input =~ $MAIL_ADDRESS_REGEX and input.length <= 256 then
            # Fix a potential problem
            # Add downcase for input

            # The script used to be hang up... I'm not sure
            # If a user Enter some uppercase after @ symbol
            # Few user met the problem and have not starting to debug

            # Since Tsk 2017 build 1
            account_mail_address = input.downcase
            puts
            puts strings['added_email'] % [account_mail_address]
            puts
            break
          else
            puts
            #puts "！メールアドレスは正しい形式で、256byte以内にて入力してください"
            #print "メールアドレス> "
            puts strings['email_invalid']
            puts

            print strings['enter_email']
            print $stringYaml['input']
          end
        end

        # Confirm sign up informations
        puts strings['confirm_info']
        puts
        puts strings['added_account'] % [$account_name]
        puts strings['added_password'] % [$account_password]
        puts strings['added_email'] % [account_mail_address]
        puts
        puts strings['start_signup']
        print $stringYaml['input']
        gets
        puts


        # Register new account on server
        #puts "サーバーにアカウントを登録しています..."
        puts strings['signup_requesting']
        puts

        # Generate Account XML
        account_xml = REXML::Document.new
        account_xml << REXML::XMLDecl.new('1.0', 'UTF-8')
        account_element = account_xml.add_element("account")
        account_element.add_element('name').add_text($account_name)
        account_element.add_element('password').add_text($account_password)
        account_element.add_element('mail_address').add_text(account_mail_address)
        # Upload to server
        $response = nil
        http = Net::HTTP.new($SERVER_ACCOUNT_ADDRESS, $SERVER_ACCOUNT_PORT)
        http.read_timeout = $http_timeout
        http.start do |s|
          $response = s.post($SERVER_ACCOUNT_PATH, account_xml.to_s, $SERVER_ACCOUNT_HEADER)
        end

        #print "サーバーからのお返事\n"
        puts strings['signup_server_response']
        puts
        $response.body.each_line do |line|
          #puts "> #{line}"
          puts "#{$stringYaml['input']}#{line}"
        end

        if $response.code == '200' then
          # Account registration success:
          $is_account_register_finish = true
          $config['account']['name'] = $account_name
          $config['account']['password'] = $account_password

          saveConfigFile()

          puts
          #puts "アカウント情報を設定ファイルに保存しました。"
          #puts "サーバーからのお返事の内容をご確認ください。"
          #puts
          #puts "Enter キーを押すと、続いて対戦結果の報告をします..."
          puts strings['signup_success']
          gets

          #puts "引き続き、対戦結果の報告をします..."
          puts strings['signup_end_message']
          puts
        else
        # Account registration failure:
          puts
          #puts "もう一度アカウント登録をやり直します..."
          puts strings['signup_failed']
          gets
        end
      end
    end
    def doAccountLogin()
      strings = $stringYaml['do_account_login']

      # Show introduction

      #puts "★設定ファイル編集\n"
      #puts "#{$variables['$WEB_SERVICE_NAME']} アカウント名とパスワードを設定します"
      #puts "※アカウント名とパスワードが分からない場合、ご利用の#{$variables['$WEB_SERVICE_NAME']}クライアント（緋行跡報告ツール等）の#{$config_file}で確認できます"
      #puts "お持ちの #{$variables['$WEB_SERVICE_NAME']} アカウント名を入力してください"
      #print "アカウント名> "

      puts strings['account_edit']
      puts strings['edit_description'] % [$WEB_SERVICE_NAME, $WEB_SERVICE_NAME, $WEB_SERVICE_NAME]
      puts strings['account_name_rules']
      puts

      # Enter account name
      print strings['enter_account_name']
      print $stringYaml['input']

      while (input = gets)
        input.strip!
        if input =~ $ACCOUNT_NAME_REGEX then
          $account_name = input
          puts
          puts strings['added_account'] % [$account_name]
          puts
          break
        else
          #puts "！アカウント名は半角英数とアンダースコア_のみで、32文字以内で入力してください"
          puts strings['account_name_rules']
          puts
        end
        #print "アカウント名> "
        print strings['enter_account_name']
        puts
        print $stringYaml['input']
        puts
      end

      # Enter password
      #puts "パスワードを入力してください\n"
      #print "パスワード> "
      puts strings['password_rules']
      puts
      print strings['enter_password']
      print $stringYaml['input']

      while (input = gets)
        input.strip!
        if (input.length >= 4 and input.length <= 16 and input != $account_name) then
          $account_password = input
          puts
          strings['added_password'] % [$account_password]
          puts
          break
        else
          #puts "！パスワードは4～16byte以内で、アカウント名と別の文字列を入力してください"
          puts strings['invalid_password']
          puts
        end
        #print "パスワード> "
        print strings['enter_password']
        print $stringYaml['input']
      end

      # Save account to config
      $config['account']['name'] = $account_name
      $config['account']['password'] = $account_password
      save_config($config_file, $config)

      #puts "アカウント情報を設定ファイルに保存しました。\n\n"
      #puts "引き続き、対戦結果の報告をします...\n\n"
      puts strings['login_end_message']
      puts
    end
    def doUploadData()
      ## The uploading process

      # Don't upload if queue is empty
      if $trackrecord.length == 0 then
        puts "報告対象データはありませんでした。"
      else
        # Split the match results and send to server
        0.step($trackrecord.length, $TRACKRECORD_POST_SIZE) do |start_row_num|
          end_row_num = [start_row_num + $TRACKRECORD_POST_SIZE - 1, $trackrecord.length - 1].min
          $response = nil # サーバーからのレスポンスデータ

          puts "#{$trackrecord.length}件中の#{start_row_num + 1}件目～#{end_row_num + 1}件目を送信しています#{$is_force_insert ? "（強制インサートモード）" : ""}...\n"

          # Generate XML to upload
          trackrecord_xml_string = trackrecord2xml_string($game_id, $account_name, $account_password, $trackrecord[start_row_num..end_row_num], $is_force_insert)
          File.open('./last_report_trackrecord.xml', 'w') do |w|
            w.puts trackrecord_xml_string
          end

          # And then send to server
          http = Net::HTTP.new($SERVER_TRACK_RECORD_ADDRESS, $SERVER_LAST_TRACK_RECORD_PORT)
          http.read_timeout = $http_timeout
          http.start do |s|
            $response = s.post($SERVER_TRACK_RECORD_PATH, trackrecord_xml_string, $SERVER_LAST_TRACK_RECORD_HEADER)
          end
          printHTTPcode($response)

          # Display upload result from server
          puts "サーバーからのお返事"
          $response.body.each_line do |line|
            puts "> #{line}"
          end
          puts

          if $response.code == '200' then
            sleep 1
            # Meaning unknown code, keep original comments
            # 特に表示しない
          else
            if $response.body.index($PLEASE_RETRY_FORCE_INSERT)
              puts "強制インサートモードで報告しなおします。1秒後に報告再開...\n\n"
              sleep 1
              $is_force_insert = true
              redo
            else
              raise "報告時にサーバー側でエラーが発生しました。処理を中断します。"
            end
          end
        end
      end
    end
  end
  module UserData
    def importConfigToVariables()
      # The following code seems to read some value from config to variables

      ##################################################
      # Meaning unknown, keep original comments

      # config.yaml がおかしいと代入時にエラーが出ることに対する格好悪い対策
      $config ||= {}
      $config['account'] ||= {}
      $config['database'] ||= {}

      $account_name = $config['account']['name'].to_s || ''
      $account_password = $config['account']['password'].to_s || ''
      ##################################################

      $updateCheck = $variables['UPDATE_CHECK']
      $networkProtocol = $variables['NETWORK_PROTOCOL']
    end
    def detectExistAccount()
      # My account detect method(simple ver)
      if $config['account']['name'] == ""
        $is_account_register_finish = false
      else
        $is_account_register_finish = true
      end
      # The old one account detect method(regulare expersion)
      # Run at the same time to prevent one of them not work.

      # != 0 means the account is not valid:
      if ($account_name =~ $ACCOUNT_NAME_REGEX) != 0
        $account_name = ''
        $account_password = ''
        $is_account_register_finish = false
      else
        $is_account_register_finish = true
      end
    end
    def doNewAccountSetup()
      strings = $stringYaml['new_account_setup']
      #puts "★#{$variables['$WEB_SERVICE_NAME']} アカウント設定（初回実行時）\n"
      #puts "#{$variables['$WEB_SERVICE_NAME']} をはじめてご利用の場合、「1」をいれて Enter キーを押してください。"
      #puts "すでに緋行跡報告ツール等でアカウント登録済みの場合、「2」をいれて Enter キーを押してください。\n"
      puts strings['first_time_running'] % [$WEB_SERVICE_NAME] + $NEW_LINE*1
      puts strings['how_to_signup'] % [$WEB_SERVICE_NAME]
      puts strings['how_to_login']

      print $stringYaml['input']

      while (input = gets)
        input.strip!
        if input == "1"
          $is_new_account = true
          puts
          break
        elsif input == "2"
          $is_new_account = false
          puts
          break
        end
        puts
        puts strings['invalid_option']
        puts
        #puts "#{$variables['$WEB_SERVICE_NAME']} をはじめてご利用の場合、「1」をいれて Enter キーを押してください。"
        #puts "すでに緋行跡報告ツール等で #{$variables['$WEB_SERVICE_NAME']} アカウントを登録済みの場合、「2」をいれて Enter キーを押してください。\n"
        puts strings['how_to_signup'] % [$WEB_SERVICE_NAME]
        puts strings['how_to_login']
        print $stringYaml['input']
      end

      if $is_new_account
        doAccountSignUp()
      else
        doAccountLogin()
      end

      saveConfigFile()
    end
    def detectUploadAllMode()
      # If upload all mode is false
      unless $is_all_report then
        puts "★登録済みの最終対戦時刻を取得"
        puts "GET http://#{$SERVER_TRACK_RECORD_ADDRESS}#{$SERVER_LAST_TRACK_RECORD_PATH}?game_id=#{$game_id}&account_name=#{$account_name}"

        http = Net::HTTP.new($SERVER_LAST_TRACK_RECORD_ADDRESS, $SERVER_LAST_TRACK_RECORD_PORT)
        http.read_timeout = $http_timeout
        $response = nil
        http.start do |s|
          $response = s.get("#{$SERVER_LAST_TRACK_RECORD_PATH}?game_id=#{$game_id}&account_name=#{$account_name}", $SERVER_LAST_TRACK_RECORD_HEADER)
        end
        printHTTPcode($response)

        if $response.code == '200' or $response.code == '204' then
          if ($response.body and $response.body != '') then
            $last_report_time = Time.parse($response.body)
            puts "サーバー登録済みの最終対戦時刻：#{$last_report_time.strftime('%Y/%m/%d %H:%M:%S')}"
          else
            $last_report_time = Time.at(0)
            puts "サーバーには対戦結果未登録です"
          end
        else
          #raise "最終対戦時刻の取得時にサーバーエラーが発生しました。処理を中断します。"
          strings = $stringYaml['error']
          puts strings['connection_failed_latest_upload_time']
          puts
          puts strings['connection_failed']
          puts

          $is_warning_exist = true
          DoExitActions()
        end

      else
        # If upload all mode is true
        puts "★全件報告モードです。サーバーからの登録済み最終対戦時刻の取得をスキップします。"
        $last_report_time = Time.at(0)
        end
    end
    def readDatafromDb()
      # Get the match results from database
      db_files = Dir::glob(NKF.nkf('-Wsxm0 --cp932', $db_file_path))

      if db_files.length > 0
        $trackrecord, $is_read_trackrecord_warning = read_trackrecord(db_files, $last_report_time + 1)
        $is_warning_exist = true if $is_read_trackrecord_warning
      else
        raise <<-MSG
        #{$config_file} に設定された#{$RECORD_SW_NAME}データベースファイルが見つかりません。
        ・#{$PROGRAM_NAME}のインストール場所が正しいかどうか、確認してください
        デフォルト設定の場合、#{$RECORD_SW_NAME}フォルダに、#{$PROGRAM_NAME}をフォルダごとおいてください。
        ・#{$config_file} を変更した場合、設定が正しいかどうか、確認してください
        MSG
      end

      puts "★対戦結果送信"
      puts ("#{$RECORD_SW_NAME}の記録から、" + $last_report_time.strftime('%Y/%m/%d %H:%M:%S') + " 以降の対戦結果を報告します。")
      puts
    end
  end
end
