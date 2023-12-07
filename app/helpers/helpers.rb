 module Helpers
  class Attachments

    @megabyte = 1048576;  # 1024 * 1024 Bytes in binary
    #Added to check file size before calling File service
    def self.size_exceeded?(content_type, file_size)
      if content_type[0,5] == 'image'
        file_size > (2*@megabyte)
      else
        file_size > (5*@megabyte)
      end
    end


   end
 end