require 'rails_helper'

RSpec.describe Api::PostsController, type: :controller do
  describe 'GET #show' do
    let!(:post) { create(:post) }

    context 'with valid id' do
      before { get :show, id: post.id, format: :json }

      it { expect(response).to have_http_status(:success) }
    end
  end
end
