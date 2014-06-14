require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.configure_rspec_metadata!
  c.hook_into :webmock
  c.ignore_hosts 'codeclimate.com'
  c.ignore_localhost = true
end
