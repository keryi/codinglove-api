require 'rails_helper'

RSpec.describe Api::PostsController, type: :routing do
  it { expect(get: 'api/posts/1').to route_to(controller: 'api/posts', action: 'show', id: '1') }
end
