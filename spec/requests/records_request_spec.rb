require 'rails_helper'

RSpec.describe "Records", type: :request do
  shared_examples_for "リクエストが成功する（200）" do
    it { expect(response.status).to eq 200 }
  end

  describe 'GET #new' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:record_today) { create(:record, user: user1) }

    context "今日のデータが存在する場合" do
      before do
        sign_in user1
        get new_record_url
      end

      it_behaves_like "リクエストが成功する（200）"

      it "@recordが取得できていること" do
        expect(controller.instance_variable_get("@record")).to eq record_today
      end
    end

    context "今日のデータが存在しない場合" do
      before do
        sign_in user2
        get new_record_url
      end

      it_behaves_like "リクエストが成功する（200）"

      it "@recordが取得できていること" do
        expect(controller.instance_variable_get("@record")).to be_a_new Record
      end
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    context "パラメータが妥当な場合" do
      subject { post records_url, params: { record: attributes_for(:record) } }

      it { is_expected.to eq 302 }
      it { expect { subject }.to change(Record, :count).by(1) }
      it { is_expected.to redirect_to root_url }
    end

    context "パラメータが不正な場合" do
      subject { post records_url, params: { record: attributes_for(:record, :invalid), format: :js } }

      it { is_expected.to eq 200 }
      it { expect { subject }.not_to change(Record, :count) }

      it "エラーが表示されること" do
        expect(subject)
        expect(response.body).to include "朝の最高血圧は数値で入力してください"
      end
    end
  end

  describe 'PUT #update' do
    let(:user) { create(:user) }
    let!(:record) { create(:record, user: user) }
    let!(:update_attributes) do
      { date: record.date, m_sbp: 100, m_dbp: 100 }
    end
    let!(:update_attributes_invalid) do
      { date: record.date, m_sbp: "str", m_dbp: 100 }
    end

    before do
      sign_in user
    end

    context "パラメータが妥当な場合" do
      subject { put record_url record, params: { date: record.date, record: update_attributes }, session: {} }

      it { is_expected.to eq 302 }
      it { expect { subject }.to change { Record.find(record.id).m_sbp }.to eq 100 }
      it { is_expected.to redirect_to root_url }
    end

    context "パラメータが不正な場合" do
      subject { put record_url record, params: { date: record.date, record: update_attributes_invalid, format: :js }, session: {} }

      it { is_expected.to eq 200 }
      it { expect { subject }.not_to change { Record.find(record.id).m_sbp } }

      it "エラーが表示されること" do
        expect(subject)
        expect(response.body).to include "朝の最高血圧は数値で入力してください"
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete record_url record }

    let(:user) { create(:user) }
    let!(:record) { create(:record, user: user) }

    before do
      sign_in user
    end

    it { is_expected.to eq 302 }
    it { expect { subject }.to change(Record, :count).by(-1) }
    it { is_expected.to redirect_to root_url }

  end
end
