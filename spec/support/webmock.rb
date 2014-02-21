require 'webmock/rspec'
WebMock.disable_net_connect! :allow_localhost => true

RSpec.configure do |config|
  config.after(:suite) do
    # To allow reporting to Code Climate / Coveralls
    WebMock.disable!
  end
end
