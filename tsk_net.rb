# coding: utf-8

require './lib/win32/open3'
include Open3
require 'rubygems'
require 'nkf'
require 'net/http'
Net::HTTP.version_1_2
require 'rexml/document'
require 'time'
require 'digest/sha1'
require 'optparse'

# Load general variables
require './lib/tenco_reporter/LibVar'
include LibVar::Condition
include LibVar::Config
include LibVar::Const

# Load common methods
require './lib/tenco_reporter/LibTsk'
include LibTsk::Console
include LibTsk::Network
include LibTsk::UserData
include LibTsk::Debug
require './lib/tenco_reporter/LibRb'
include LibRb::Environments
include LibRb::InputOutput
require './lib/tenco_reporter/LibProxy'
include LibProxy::PluggableTransport::Obfs4proxy

# Tensokukan vanilla libraries
require './lib/tenco_reporter/config_util'
include TencoReporter::ConfigUtil
require './lib/tenco_reporter/track_record_util'
include TencoReporter::TrackRecordUtil

# If tsk net config file was missing, print an error and exit program.
exist_string = File.exist?($string_file)
exist_config = File.exist?($config_file)
exist_env = File.exist?($env_file)
exist_variables = File.exist?($var_file)

if exist_string
  $stringYaml = load_config($string_file)
else
  puts "#{string_file}: #{exist_string}"
  gets
  exit
end

if exist_config
  $config = load_config($config_file)
else
  puts "#{config_file}: #{exist_config}"
end
if exist_env
  $env = load_config($env_file)
else
  puts "#{env_file}: #{exist_env}"
end
if exist_variables
  $variables = load_config($var_file)
else
  puts "#{var_file}: #{exist_variables}"
end

unless exist_config & exist_env & exist_variables
  puts $stringYaml['error']['config_file_missing']
  gets
  exit
end
# The general variables were loaded but not initialized
# Use this LibVar method to fill them
InitializeConstVar()

# Start Program
begin
  # Check if program running on XP
  DetectWindowsXP()
  if $running_on_XP
    # Do Windowx XP extra operations in this code block
    # Windows XP conhost isn't truly support cp65001 UTF-8
    # So convert stdout to local codepage
    StdoutToAnsiConverter()
  end

  parseLaunchArguments()
  importConfigToVariables()
  printWellcomeMessage()
  doDebugAction()
  detectExistAccount()

  if $networkProtocol.upcase == 'OBFS4'
    loadObfs4Config()
    ManageObfs4proxyProcess('start')

    while $obfs4_ready == false
      detectObfs4proxyStatus()
    end
  end

  if $updateCheck
    doUpdateCheck()
  end

  if $is_account_register_finish != true
    doNewAccountSetup()
  end

  # Get the account-based latest upload time from server
  $last_report_time = nil
  $response = nil
  detectUploadAllMode()
  readDatafromDb()
  doUploadData()

  # Exit message output
  DoExitActions()

### Overall error handling ###
rescue => ex
  if $config && $config['account'] then
    $config['account']['name']     = '<secret>' if $config['account']['name']
    $config['account']['password'] = '<secret>' if $config['account']['password']
  end

  puts
  #puts "処理中にエラーが発生しました。処理を中断します。\n"
  puts $error_strings['do_not_understand_japanese_1']
  puts
  #puts '### エラー詳細ここから ###'
  puts $error_strings['do_not_understand_japanese_2']
  puts
  puts ex.to_s
  puts
  puts ex.backtrace.join("\n")
  #puts ($config ? $config.to_yaml : "config が設定されていません。")
  puts ($config ? $config.to_yaml : $error_strings['do_not_understand_japanese_4'])
  if $response then
    puts
    #puts "<サーバーからの最後のメッセージ>"
    #puts "HTTP status code : #{$response.code}"
    puts $error_strings['do_not_understand_japanese_3']
    puts $error_strings['do_not_understand_japanese_5'] % [$response.code]
    puts $response.body
  end
  puts
  #puts '### エラー詳細ここまで ###'
  puts $error_strings['do_not_understand_japanese_2']

  File.open($ERROR_LOG_PATH, 'w') do |log|
    log.puts "#{Time.now.strftime('%Y/%m/%d %H:%M:%S')} #{File::basename(__FILE__)} #{$PROGRAM_VERSION}"
    log.puts ex.to_s
    log.puts ex.backtrace.join("\n")
    #log.puts $config ? $config.to_yaml : "config が設定されていません。"
    log.puts $config ? $config.to_yaml : $error_strings['do_not_understand_japanese_4']
    if $response then
      #log.puts "<サーバーからの最後のメッセージ>"
      #log.puts "HTTP status code : #{$response.code}"
      log.puts $error_strings['do_not_understand_japanese_3']
      log.puts $error_strings['do_not_understand_japanese_5'] % [$response.code]
      log.puts $response.body
    end
    #log.puts '********'
    log.puts $error_strings['log_endline']
  end

  puts
  #puts "上記のエラー内容を #{$ERROR_LOG_PATH} に書き出しました。"
  puts $error_strings['do_not_understand_japanese_6'] % [$ERROR_LOG_PATH]
  puts

  #puts "Enter キーを押すと、処理を終了します。"
  puts $error_strings['do_not_understand_japanese_7']
  exit if gets
end
