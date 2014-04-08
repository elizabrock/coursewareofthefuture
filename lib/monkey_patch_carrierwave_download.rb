module CarrierWave
  module Uploader
    module Download
      class RemoteFile
        def filename_from_header
          @uri.path
        end

        def read
          file.body
        end

      private
        def file
          if @file.blank?
            http = Net::HTTP.new(@uri.host, @uri.port)
            if @uri.scheme == "https"
              http.use_ssl = true
            end
            http.ssl_version = :SSLv3
            response = http.request_get(@uri.request_uri)
            @file = response
            @file = @file.is_a?(String) ? StringIO.new(@file) : @file
          end
          @file

        rescue Exception => e
          raise CarrierWave::DownloadError, "could not download file: #{e.message}"
        end
      end
    end
  end
end
