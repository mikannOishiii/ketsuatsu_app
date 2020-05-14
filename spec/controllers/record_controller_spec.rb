require 'rails_helper'

RSpec.describe RecordsController, type: :controller do
  describe 'GET #new' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let!(:record_today) { create(:record, user: user1) }

    context "今日のデータが存在する場合" do
      before do
        sign_in user1
        get :new
      end

      it "@recordが取得できていること" do
        expect(assigns(:record)).to eq record_today
      end

      it 'has a 200 status code' do
        expect(response).to have_http_status(:success)
      end
    end

    context "今日のデータが存在しない場合" do
      before do
        sign_in user2
        get :new
      end

      it "@recordが取得できていること" do
        expect(assigns(:record)).to be_a_new Record
      end
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:record_attributes) { attributes_for(:record) }

    before do
      sign_in user
    end

    it "saves new record in the DB" do
      expect do
        post :create, params: { record: record_attributes }
      end.to change(Record, :count).by(1)
    end

    it "redirect to root_url" do
      post :create, params: { record: record_attributes }
      expect(response).to redirect_to root_url
    end
  end

  describe 'PATCH #update' do
    let(:user) { create(:user) }
    let!(:record) { create(:record, user: user) }
    let(:update_attributes) do
      { date: record.date, m_sbp: 100, m_dbp: 100 }
    end

    before do
      sign_in user
    end

    it 'saves updated record' do
      expect do
        patch :update, params: { id: record.id, record: update_attributes }, session: {}
      end.to change(Record, :count).by(0)
    end

    it 'updates updated record' do
      patch :update, params: { id: record.id, record: update_attributes }, session: {}
      expect(record.reload.m_sbp).to eq update_attributes[:m_sbp]
      expect(record.reload.m_dbp).to eq update_attributes[:m_dbp]
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let!(:record) { create(:record, user: user) }

    before do
      sign_in user
    end

    it '記録を削除できる' do
      expect do
        delete :destroy, params: { id: record.id }
      end.to change(Record, :count).by(-1)
    end
  end
end
