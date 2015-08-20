require 'rails_helper'

RSpec.describe ApisController, type: :controller do
  describe 'GET #index' do
    before { get :index }

    it { expect(response).to have_http_status(:success) }
    it { expect(assigns(:host)).to eq request.host }
  end
end
