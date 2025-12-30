require 'rails_helper'

RSpec.describe "Oauths", type: :request do
  describe 'GET /failure' do
    it 'リダイレクトされる' do
      get auth_failure_path
      expect(response).to have_http_status 302
      expect(response).to redirect_to root_path
    end
  end
end
