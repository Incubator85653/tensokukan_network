# coding: utf-8

require 'nkf'

# This file is not going to convert stdout to cp932.
# Don't get confused with the file name...

# Tensokukan 2017 added Unicode support.
# This lib make old versions able to output cp65001.

# convert $stdout to cp65001...
if !defined?($stdout._write)
  class << $stdout
    alias :_write :write
    def write(str)
	# This stupid converter is going to make cp1252 system able to display CJK characters.
      _write NKF.nkf('-sxm0 --cp65001', str.to_s)
    end
  end
end

# Summary:
#   I don't care what makes someone force his program output cp932,
# and I don't care what kind of default output encoding used by Ruby.

#   If someone wrote this file for cp932 output,
# then I'm going to change cp932 to cp65001 for Unicode support.