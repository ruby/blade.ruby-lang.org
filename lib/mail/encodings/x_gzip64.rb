# frozen_string_literal: true

require 'mail/encodings/base64'
require 'zlib'

module Mail
  module Encodings
    class XGzip64 < Base64
      NAME = 'x-gzip64'
      PRIORITY = 3
      Encodings.register(NAME, self)

      def self.decode(str)
        base64str = Utilities.decode_base64(str)
        ActiveSupport::Gzip.decompress(base64str)
      end
    end
  end
end
