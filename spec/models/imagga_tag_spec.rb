require 'rails_helper'

RSpec.describe ImaggaTag, type: :model do
  context 'associations' do
    it { should belong_to(:post) }
  end
end
