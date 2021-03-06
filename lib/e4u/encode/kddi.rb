module E4U
  module Encode
    module KDDI
      autoload :Cp932,   'e4u/encode/kddi/cp932'
      autoload :Utf8,    'e4u/encode/kddi/utf8'
      autoload :Unicode, 'e4u/encode/kddi/unicode'

      def self.encode str, from, to
        raise unless from[:carrier] == :kddi
        if to[:carrier] == :kddi
          encode_carrier(str, from, to)
        else
          encode_encoding(str, from, to)
        end
      end

      private

      def self.encode_carrier str, from, to
        return encode_encoding(str, from, to) if from[:encoding] != :unicode
        case to[:encoding]
        when :sjis
          from[:encoding] = :sjis
          Unicode.to_cp932(Encoding.to_cp932(str))
        when :utf8
          from[:encoding] = :utf8
          Unicode.to_utf8(str)
        else
          raise
        end
      end

      def self.encode_encoding str, from, to
        case from[:encoding]
        when :sjis
          from[:encoding] = :unicode
          Encoding.to_utf8(Cp932.to_kddi_unicode(str))
        when :utf8
          from[:encoding] = :unicode
          Utf8.to_kddi_unicode(str)
        when :unicode
          from[:carrier] = :google
          Unicode.to_google_unicode(str)
        else
          raise
        end
      end
    end
  end
end
