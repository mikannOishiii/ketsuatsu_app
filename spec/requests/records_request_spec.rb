require 'rails_helper'

RSpec.describe "Records", type: :request do

  describe 'GET #new' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let!(:record_today) { create(:record, user: user1) }

    context "今日のデータが存在する場合" do
      before do
        sign_in user1
      end

      it "リクエストが成功すること" do
        get new_record_url
        expect(response.status).to eq 200
      end

      it "@recordが取得できていること" do
        get new_record_url
        expect(controller.instance_variable_get("@record")).to eq record_today
      end
    end

    context "今日のデータが存在しない場合" do
      before do
        sign_in user2
      end

      it "リクエストが成功すること" do
        get new_record_url
        expect(response.status).to eq 200
      end

      it "@recordが取得できていること" do
        get new_record_url
        expect(controller.instance_variable_get("@record")).to be_a_new Record
      end
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }

    context "パラメータが妥当な場合" do
      before do
        sign_in user
      end

      it "リクエストが成功すること" do
        post records_url, params: { record: attributes_for(:record) }
        expect(response.status).to eq 302
      end

      it "recordが登録されること" do
        expect do
          post records_url, params: { record: attributes_for(:record) }
        end.to change(Record, :count).by(1)
      end

      it "リダイレクトすること" do
        post records_url, params: { record: attributes_for(:record) }
        expect(response).to redirect_to root_url
      end
    end

    context "パラメータが不正な場合" do
      before do
        sign_in user
      end

      it "リクエストに成功すること" do
        post records_url, params: { record: attributes_for(:record, :invalid) }
        expect(response.status).to eq 200
      end

      it "recordが登録されないこと" do
        expect do
          post records_url, params: { record: attributes_for(:record, :invalid) }
        end.to_not change(Record, :count)
      end

      it "エラーが表示されること" do
        post records_url, params: { record: attributes_for(:record, :invalid) }
        expect(response.body).to include "朝の最高血圧は数値で入力してください"
      end
    end
  end

  describe 'PUT #update' do
    let(:user) { create(:user) }
    let!(:record) { create(:record, user: user) }
    let(:update_attributes) do
      { date: record.date, m_sbp: 100, m_dbp: 100 }
    end
    let(:update_attributes_invalid) do
      { date: record.date, m_sbp: "str", m_dbp: 100 }
    end

    context "パラメータが妥当な場合" do
      before do
        sign_in user
      end

      it "リクエストに成功すること" do
        put record_url record, params: { date: record.date, record: update_attributes }, session: {}
        expect(response.status).to eq 302
      end
      it "recordが更新されること" do
        expect do
          put record_url record, params: { id: record.id, record: update_attributes }, session: {}
        end.to change { Record.find(record.id).m_sbp }.to eq 100
      end
      it "リダイレクトすること"  do
        put record_url record, params: { id: record.id, record: update_attributes }, session: {}
        expect(response).to redirect_to root_url
      end
    end

    context "パラメータが不正な場合" do
      before do
        sign_in user
      end

      it "リクエストに成功すること" do
        put record_url record, params: { date: record.date, record: update_attributes_invalid }, session: {}
        expect(response.status).to eq 200
      end

      it "recordが更新されないこと" do
        expect do
          put record_url record, params: { id: record.id, record: update_attributes_invalid }, session: {}
        end.to_not change { Record.find(record.id).m_sbp }
      end
      it "エラーが表示されること" do
        put record_url record, params: { date: record.date, record: update_attributes_invalid }, session: {}
        expect(response.body).to include "朝の最高血圧は数値で入力してください"
      end
    end
  end
end
