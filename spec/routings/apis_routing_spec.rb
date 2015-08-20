require 'rails_helper'

RSpec.describe ApisController, type: :routing do
  it { expect(get: '/apis').to route_to(controller: 'apis', action: 'index') }
end
