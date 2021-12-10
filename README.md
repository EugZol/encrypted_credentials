# Encrypted credentials

If you ever wanted to:

✅ edit Rails [encrypted credentials](https://guides.rubyonrails.org/security.html#environmental-security) without a need to run Rails environment (e.g. from host machine inside a docker volume, from system user which doesn't have Rails installed, etc.)

✅ employ Rails-compatible encrypted credentials in your non-Rails Ruby app

...this gem is for you.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'encrypted_credentials'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install encrypted_credentials

## Usage (CLI)

```
# To open EDITOR (nano by default) for 'development.yml.enc', using 'development.key' as key:
edit_credentials -i config/credentials/development.yml.enc

# To open EDITOR (nano by default) for 'credentials.yml.enc', using 'master.key' as key:
edit_credentials -i config/credentials.yml.enc
```

Run `edit_credentials --help` for full list of options.

## Usage (Ruby)

```
require 'encrypted_credentials/coder'

# Decrypt

key_hex = "9b3821b4116cec2f1db839151eaf18bb"
data = "gf3IRwit9tIvWtaa+Ytf7ulImIyIooOH+w==--2YttW0Yus3vxR9I+--ytgdvdU9L3CnTvCSqzFzuw=="

EncryptedCredentials::Coder.decrypt(data, key_hex) #=> "some_key: some_value\n"

# Encrypt

key_hex = EncryptedCredentials::Coder.generate_key_hex
rails_compatible_encrypted_data = EncryptedCredentials::Coder.encrypt("some_key: some_value", key_hex, true)
File.write('master.key', key_hex)
File.write('credentials.yml.enc', rails_compatible_encrypted_data)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/EugZol/credentials.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
