# coding: utf-8

# This file for general variables
# All the general var in main is hard to read
module LibVar
  module Condition
    # Some conditions to affect program behavior
    $is_force_insert = false # Forced insert mode. Set to false when getting started
    $is_all_report = false # Upload all mode
    $updateCheck = false # Detect update check
    $is_new_account = false # New account or login
    $is_account_register_finish = false # Detect if there is a account signed up
    $networkProtocol = nil
    $obfs4_ready = false # Wait until obfs4 client is OK
    $running_on_XP = false # Extra operations if Windows XP
  end
  module Config
    ### Load config to memory ###
    # Set config file path
    $string_file = 'string.yaml'
    $config_file = 'config.yaml'
    $env_file = 'env.yaml'
    $var_file = 'variables.yaml'
    # Create general variables
    $stringYaml = nil
    $config = nil
    $env = nil
    $variables = nil
  end
  module Const
    # Simulate new line
    $NEW_LINE = nil

    # User account and password
    $account_name = nil
    $account_password = nil

    # Database file path
    $db_file_path = nil

    # Tenco service edition(tenco.info/2, /5 etc)
    $game_id = nil

    # Seems these variables were used to find server.
    # Default HTTP request header
    $HTTP_REQUEST_HEADER = nil
    # Two different request header for obfs4 forward server.
    $HTTP_REQUEST_HEADER_MAIN = nil
    $HTTP_REQUEST_HEADER_STATIC = nil
    # SERVER_TRACK_RECORD
    $SERVER_TRACK_RECORD_HOST = nil
    $SERVER_TRACK_RECORD_ADDRESS = nil
    $SERVER_TRACK_RECORD_PORT = nil
    $SERVER_TRACK_RECORD_PATH = nil
    $SERVER_TRACK_RECORD_HEADER = nil
    # SERVER_LAST_TRACK_RECORD
    $SERVER_LAST_TRACK_RECORD_HOST = nil
    $SERVER_LAST_TRACK_RECORD_ADDRESS = nil
    $SERVER_LAST_TRACK_RECORD_PORT = nil
    $SERVER_LAST_TRACK_RECORD_PATH = nil
    $SERVER_LAST_TRACK_RECORD_HEADER = nil
    # SERVER_ACCOUNT
    $SERVER_ACCOUNT_HOST = nil
    $SERVER_ACCOUNT_ADDRESS = nil
    $SERVER_ACCOUNT_PORT = nil
    $SERVER_ACCOUNT_PATH = nil
    $SERVER_ACCOUNT_HEADER = nil
    # CLIENT_LATEST_VERSION
    $CLIENT_LATEST_VERSION_HOST = nil
    $CLIENT_LATEST_VERSION_ADDRESS = nil
    $CLIENT_LATEST_VERSION_PORT = nil
    $CLIENT_LATEST_VERSION_PATH = nil
    $CLIENT_LATEST_VERSION_HEADER = nil
    # CLIENT_SITE_URL
    $CLIENT_SITE_URL = nil

    # Vaild account name and email address characters, regular expression
    $ACCOUNT_NAME_REGEX = nil
    $MAIL_ADDRESS_REGEX = nil

    # Other corss-method variables
    $RECORD_SW_NAME = nil
    $DB_TR_TABLE_NAME = nil
    $DUPLICATION_LIMIT_TIME_SECONDS = nil
    $TRACKRECORD_POST_SIZE = nil
    $PLEASE_RETRY_FORCE_INSERT = nil
    $WEB_SERVICE_NAME = nil
    $error_strings = nil
    $http_timeout = nil
    # Match result
    $trackrecord = nil
    # Meaning unknown variables, keep original comments
    $is_read_trackrecord_warning = nil # 対戦結果読み込み時に警告があったかどうか
    $is_warning_exist = nil # 警告メッセージがあるかどうか
    # Error Log path
    $ERROR_LOG_PATH = nil
    def InitializeConstVar()
      # Simulate new line
      $NEW_LINE = "\n"

      # User account and password
      $account_name = ""
      $account_password = ""

      # Database file path
      $db_file_path = $config['database']['file_path'].to_s || $variables['DEFAULT_DATABASE_FILE_PATH']

      # Tenco service edition(tenco.info/2, /5 etc)
      $game_id = $variables['DEFAULT_GAME_ID']

      # Seems these variables were used to find server.
      # Default HTTP request header
      $HTTP_REQUEST_HEADER = $variables['HTTP_REQUEST_HEADER'][0]
      # Two different request header for obfs4 forward server.
      $HTTP_REQUEST_HEADER_MAIN = $HTTP_REQUEST_HEADER
      $HTTP_REQUEST_HEADER_STATIC = $HTTP_REQUEST_HEADER
      # SERVER_TRACK_RECORD
      $SERVER_TRACK_RECORD_HOST = $env['server']['track_record']['host'].to_s
      $SERVER_TRACK_RECORD_ADDRESS = $env['server']['track_record']['address'].to_s
      $SERVER_TRACK_RECORD_PORT = $env['server']['track_record']['port'].to_s
      $SERVER_TRACK_RECORD_PATH = $env['server']['track_record']['path'].to_s
      $SERVER_TRACK_RECORD_HEADER = $HTTP_REQUEST_HEADER
      # SERVER_LAST_TRACK_RECORD
      $SERVER_LAST_TRACK_RECORD_HOST = $env['server']['last_track_record']['host'].to_s
      $SERVER_LAST_TRACK_RECORD_ADDRESS = $env['server']['last_track_record']['address'].to_s
      $SERVER_LAST_TRACK_RECORD_PORT = $env['server']['last_track_record']['port'].to_s
      $SERVER_LAST_TRACK_RECORD_PATH = $env['server']['last_track_record']['path'].to_s
      $SERVER_LAST_TRACK_RECORD_HEADER = $HTTP_REQUEST_HEADER
      # SERVER_ACCOUNT
      $SERVER_ACCOUNT_HOST = $env['server']['account']['host'].to_s
      $SERVER_ACCOUNT_ADDRESS = $env['server']['account']['address'].to_s
      $SERVER_ACCOUNT_PORT = $env['server']['account']['port'].to_s
      $SERVER_ACCOUNT_PATH = $env['server']['account']['path'].to_s
      $SERVER_ACCOUNT_HEADER = $HTTP_REQUEST_HEADER
      # CLIENT_LATEST_VERSION
      $CLIENT_LATEST_VERSION_HOST = $env['client']['latest_version']['host'].to_s
      $CLIENT_LATEST_VERSION_ADDRESS = $env['client']['latest_version']['address'].to_s
      $CLIENT_LATEST_VERSION_PORT = $env['client']['latest_version']['port'].to_s
      $CLIENT_LATEST_VERSION_PATH = $env['client']['latest_version']['path'].to_s
      $CLIENT_LATEST_VERSION_HEADER = $HTTP_REQUEST_HEADER
      # CLIENT_SITE_URL
      $CLIENT_SITE_URL = "http://#{$env['client']['site']['host']}#{$env['client']['site']['path']}"

      # Vaild account name and email address characters, regular expression
      $ACCOUNT_NAME_REGEX = /\A[a-zA-Z0-9_]{1,32}\z/
      $MAIL_ADDRESS_REGEX = /\A[\x01-\x7F]+@(([-a-z0-9]+\.)*[a-z]+|\[\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\])\z/

      # Other corss-method variables
      $RECORD_SW_NAME = $variables['RECORD_SW_NAME']
      $DB_TR_TABLE_NAME = $variables['DB_TR_TABLE_NAME']
      $DUPLICATION_LIMIT_TIME_SECONDS = $variables['DUPLICATION_LIMIT_TIME_SECONDS']
      $TRACKRECORD_POST_SIZE = $variables['TRACKRECORD_POST_SIZE']
      $PLEASE_RETRY_FORCE_INSERT = $variables['PLEASE_RETRY_FORCE_INSERT']
      $WEB_SERVICE_NAME = $variables['WEB_SERVICE_NAME']
      $error_strings = $stringYaml['error']
      $http_timeout = $variables['HTTP_REQUEST_TIMEOUT_SECONDS']
      # Match result
      $trackrecord = []
      # Meaning unknown variables, keep original comments
      $is_read_trackrecord_warning = false # 対戦結果読み込み時に警告があったかどうか
      $is_warning_exist = false # 警告メッセージがあるかどうか
      # Error Log path
      $ERROR_LOG_PATH = $variables['ERROR_LOG_PATH']
    end
  end
end
