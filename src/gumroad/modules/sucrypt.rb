module DeveloperMeetUp
  module GumroadExample
    # # #
    module SuCrypt
      require 'openssl'

      refine String do
        def encrypt(key)
          cipher = OpenSSL::Cipher.new('AES-128-CBC').encrypt
          cipher.key = Digest::SHA1.hexdigest key
          s = cipher.update(self) + cipher.final
          s.unpack1('H*').upcase
        end

        def decrypt(key)
          cipher = OpenSSL::Cipher.new('AES-128-CBC').decrypt
          cipher.key = Digest::SHA1.hexdigest key
          s = [self].pack('H*').unpack('C*').pack('c*')
          cipher.update(s) + cipher.final
        end
      end
      # # #
    end
  end
end
