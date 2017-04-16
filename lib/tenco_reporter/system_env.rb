# coding: utf-8

module LibRb
  def GetWindowsVersion()
    sysVer = `ver`
    return sysVer
  end
  def DetectWindowsXP()
    isXP = GetWindowsVersion().include? $variables['WINDOWS_XP_VERSION_STR']

    if isXP
      #TODO
    end
  end
end
