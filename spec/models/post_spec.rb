require 'rails_helper'

RSpec.describe Post, type: :model do
  it { should validate_presence_of(:ref_id) }
  it { should validate_uniqueness_of(:ref_id) }
end
