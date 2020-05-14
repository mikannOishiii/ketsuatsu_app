require 'rails_helper'

RSpec.describe Record, type: :model do
  let(:user) { create(:user) }

  it "紐づくアカウントがあれば有効であること" do
    record = build(:record, user: user)
    expect(record).to be_valid
  end

  it "紐づくアカウントがなければ無効であること" do
    record = build(:record, user: nil)
    expect(record).not_to be_valid
  end

  it "数値が4桁以上だと無効であること" do
    record = build(:record, user: user, m_sbp: 1111)
    expect(record).not_to be_valid
  end

  it "数値に小数点が含まれていると無効であること" do
    record = build(:record, user: user, m_sbp: 11.1)
    expect(record).not_to be_valid
  end

  it "数値が空でも有効であること" do
    record = build(:record, user: user, m_sbp: "")
    expect(record).to be_valid
  end

  it "数値に文字列が入っていると無効であること" do
    record = build(:record, user: user, m_sbp: "str")
    expect(record).not_to be_valid
  end

  it "日付がないと無効であること" do
    record = build(:record, user: user, date: "")
    expect(record).not_to be_valid
  end

  it "日付が未来だと無効であること" do
    record = build(:record, user: user, date: Time.current.tomorrow)
    expect(record).not_to be_valid
  end

  it "メモは20文字以内であること" do
    record = build(:record, user: user, memo: "a" * 20)
    expect(record).to be_valid
  end

  it "メモは21文字以上だと無効であること" do
    record = build(:record, user: user, memo: "a" * 21)
    expect(record).not_to be_valid
  end

  it "ユーザー同士で日付が重複していても有効であること" do
    other_user = create(:user, account_name: "otheruser")
    other_user_record = create(:record, user: other_user)
    user_record = build(:record, user: user)
    expect(user_record).to be_valid
    expect(other_user_record).to be_valid
  end
end
