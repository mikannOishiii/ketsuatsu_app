require 'rails_helper'

RSpec.describe "Admins::StaticPages", type: :request do
  let!(:admin) { create(:admin) }

  describe "GET /dashboard" do
    context "ログインしているとき" do
      before do
        sign_in admin
        get admins_dashboard_url
      end

      it "リクエストが成功すること" do
        expect(response.status).to eq 200
      end
    end

    context "ログインしていないとき" do
      before do
        get admins_dashboard_url
      end

      it "リクエストが成功すること" do
        expect(response.status).to eq 302
      end

      it "リダイレクトされること" do
        expect(response).to redirect_to new_admin_session_url
      end
    end
  end
end
