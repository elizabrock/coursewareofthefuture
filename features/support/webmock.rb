require 'webmock/cucumber'

WebMock.disable_net_connect! :allow_localhost => true

at_exit do
  # To allow reporting to Code Climate
  WebMock.disable!
end

image = File.read(Rails.root.join('features', 'support', 'files', 'arson_girl.jpg'))
Before do
  WebMock.stub_request(:get, "http://example.com/image.png").to_return( body: image, :status   => 200, :headers  => { 'Content-Type' => "image/jpeg; charset=UTF-8" } )
  WebMock.stub_request(:get, "https://example.com/image.png").to_return( body: image, :status   => 200, :headers  => { 'Content-Type' => "image/jpeg; charset=UTF-8" } )
end
