require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe 'GET #new' do
    it "リクエストが成功すること" do
      get new_admin_session_url
      expect(response.status).to eq 200
    end
  end

  describe "POST #create" do
    let!(:admin) { create(:admin) }

    context "パラメータが妥当な場合" do
      before do
        post admin_session_url, params: { admin: attributes_for(:admin) }
      end

      it "リクエストが成功すること" do
        expect(response.status).to eq 302
      end

      it "リダイレクトすること" do
        expect(response).to redirect_to admins_dashboard_url
      end
    end

    context "パラメータが不正の場合" do
      before do
        post admin_session_url, params: { admin: attributes_for(:admin, :invalid) }
      end

      it "リクエストが成功すること" do
        expect(response.status).to eq 200
      end

      it "エラーメッセージが表示されること" do
        expect(response.body).to include "アカウント名またはパスワードが違います。"
      end
    end
  end

  describe "DELETE #destroy" do
    let(:admin) { create(:admin) }

    before do
      sign_in admin
    end

    it "リクエストが成功すること" do
      delete destroy_admin_session_url
      expect(response.status).to eq 302
    end

    it "リダイレクトされること" do
      delete destroy_admin_session_url
      expect(response).to redirect_to new_admin_session_url
    end
  end
end
