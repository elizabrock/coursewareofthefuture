require 'spec_helper'

describe User do
  it { should validate_presence_of :github_access_token }
end
