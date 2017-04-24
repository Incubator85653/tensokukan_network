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
end
