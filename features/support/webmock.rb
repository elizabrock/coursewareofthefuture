require 'webmock/cucumber'
WebMock.disable_net_connect! :allow_localhost => true

at_exit do
  # To allow reporting to Code Climate
  WebMock.disable!
end
