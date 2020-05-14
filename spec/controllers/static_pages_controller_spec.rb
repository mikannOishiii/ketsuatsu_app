require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  describe "GET #home" do
    let(:user) { create(:user) }
    let!(:record_today) { create(:record, user: user) }
    let!(:record_lastmonth) { create(:record, user: user, date: Time.now.ago(31.days)) }
    let!(:records) { user.records.current_month }

    context "ログインしていて, 今日のデータが存在する場合" do
      before do
        sign_in user
        get :home
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "chartとtebleテンプレートが呼び出されている" do
        expect(response).to render_template :home
      end

      it "@recordsが取得できていること" do
        expect(assigns(:records)).to eq records
        expect(assigns(:records)).not_to include record_lastmonth
      end
    end

    context "ログインしていない場合" do
      before do
        get :home
      end

      it "welcomeテンプレートが呼び出されている" do
        expect(response).to render_template :home
      end
    end
  end

  describe "GET #terms" do
    it "returns http success" do
      get :terms
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #export" do
    let(:user) { create(:user) }
    let!(:record_lastmonth) { create(:record, user: user, date: Time.now.ago(31.days)) }
    let!(:records_lastmonth) { user.records.last_month }

    context "ログインしていない場合" do
      before do
        get :export
      end

      it "リダイレクトされる" do
        expect(response).to redirect_to login_url
      end
    end

    context "ログインしている場合" do
      before do
        sign_in user
        get :export
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "exportテンプレートが呼び出されている" do
        expect(response).to render_template :export
      end

      it "@recordsが取得できていること" do
        expect(assigns(:records)).to eq records_lastmonth
      end

      describe "CSV format" do
        render_views
        before { get :export, format: "csv" }

        it "csvフォーマットである" do
          expect(response.headers["Content-Type"]).to include "text/csv"
        end

        attributes = %w(date m_sbp m_dbp m_pulse n_sbp n_dbp n_pulse memo)

        attributes.each do |field|
          it "カラム：#{field}を持つ" do
            expect(response.body).to include field
          end
        end

        it "行数が一致する" do
          num_of_rows = 1 + records_lastmonth.count
          expect(response.body.split(/\n/).size).to eq num_of_rows
        end
      end
    end
  end
end
