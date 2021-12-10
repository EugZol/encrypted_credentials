require 'openssl'
require 'base64'
require 'securerandom'

# References:
# - https://github.com/rails/rails/blob/main/activesupport/lib/active_support/encrypted_file.rb
# - https://github.com/rails/rails/blob/b71a9ccce04ac08e159d4a21de91a8d76f13d8d0/activesupport/lib/active_support/message_encryptor.rb#L147
# - https://github.com/rails/rails/blob/174ee7bb602f63e7a5c44ec52e6592f3a5dd10b1/activesupport/lib/active_support/message_encryptor.rb#L163

module EncryptedCredentials
  class Coder
    def self.decrypt(data_bin, key_hex)
      encrypted_data, iv, auth_tag = data_bin.split("--").map { |v| Base64.strict_decode64(v) }
      key = [key_hex].pack('H*')

      cipher_type =
        case key.bytes.length
        when 16
          'aes-128-gcm'
        when 32
          'aes-256-gcm'
        else
          raise "Wrong key length: #{key.bytes.length}"
        end

      raise "Unauthenticated message" if auth_tag.nil? || auth_tag.bytes.length != 16

      cipher = OpenSSL::Cipher.new(cipher_type)
      cipher.decrypt
      cipher.key = key
      cipher.iv = iv
      cipher.auth_tag = auth_tag
      cipher.auth_data = ""

      decrypted_data = cipher.update(encrypted_data)
      decrypted_data << cipher.final

      if decrypted_data.bytes[0..1] == [4, 8]
        Marshal.load(decrypted_data)
      else
        decrypted_data
      end
    end

    def self.generate_key_hex(cipher = 'aes-128-gcm')
      key_length =
        case cipher
        when 'aes-128-gcm'
          16
        when 'aes-256-gcm'
          32
        else
          raise "Unsupported cipher: #{cipher}"
        end

      SecureRandom.hex(key_length)
    end

    def self.encrypt(data_bin, key_hex, use_marshal = true)
      key = [key_hex].pack('H*')

      cipher_type =
        case key.bytes.length
        when 16
          'aes-128-gcm'
        when 32
          'aes-256-gcm'
        else
          raise "Wrong key length: #{key.bytes.length}"
        end

      cipher = OpenSSL::Cipher.new(cipher_type)
      cipher.encrypt
      cipher.key = key
      iv = cipher.random_iv
      cipher.auth_data = ""

      data = data_bin
      data = Marshal.dump(data) if use_marshal
      encrypted_data = cipher.update(data)
      encrypted_data << cipher.final

      [encrypted_data, iv, cipher.auth_tag].map{ |x| Base64.strict_encode64(x) }.join('--')
    end
  end
end
