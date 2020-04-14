require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do


  describe "GET #home" do
    let(:user) { create(:user) }
    let!(:record_today) { create(:record, user: user) }
    let!(:record_lastmonth) { create(:record, user: user, date: Time.now.ago(31.days)) }
    let!(:records){ user.records.current_month }

    context "ログインしていて, 今日のデータが存在する場合" do
      before do
        sign_in user
        get :home
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "@recordが取得できていること" do
        expect(assigns(:record)).to eq record_today
      end

      it "@recordsが取得できていること" do
        expect(assigns(:records)).to eq records
        expect(records).not_to include record_lastmonth
      end
    end

    context "ログインしていない場合" do
      before do
        get :home
      end
    end
  end

  describe "GET #terms" do
    it "returns http success" do
      get :terms
      expect(response).to have_http_status(:success)
    end
  end

end
