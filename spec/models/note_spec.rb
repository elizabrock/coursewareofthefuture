require 'rails_helper'

RSpec.describe Note do
  it { should validate_presence_of :content }
end
