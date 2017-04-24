# coding: utf-8
require 'iconv'

module LibRb
  module Environments
    def GetWindowsVersion()
      sysVer = `ver`
      return sysVer
    end
    def DetectWindowsXP()
      $running_on_XP = GetWindowsVersion().include? $variables['WINDOWS_XP_VERSION_STR']
    end
  end

  module InputOutput
    def saveConfigFile()
      # Update configuration file
      save_config($config_file, $config)
      save_config($var_file, $variables)
    end
    def parseLaunchArguments()
      ### Define available program launch options
      opt = OptionParser.new

      # If '-a' was specified
      # Mark upload all mode to true
      opt.on('-a') {|v| $is_all_report = true}

      # Parse the arguments
      opt.parse!(ARGV)
    end
    def StdoutToAnsiConverter()
      # convert $stdout to ansi
      #TODO : get the codepage automatically
      if !defined?($stdout._write)
        class << $stdout
          alias :_write :write
          def write(str)
            _write Iconv.conv('cp936', 'utf-8//IGNORE', str)
          end
        end
      end
    end
  end
end
