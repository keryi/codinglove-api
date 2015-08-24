require 'rails_helper'

RSpec.describe Post, type: :model do
  context 'validations' do
    it { should validate_presence_of(:ref_id) }
    it { should validate_uniqueness_of(:ref_id) }
  end

  context 'associations' do
    it { should have_many(:imagga_tags) }
  end
end
