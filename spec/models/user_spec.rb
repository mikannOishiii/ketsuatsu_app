require 'rails_helper'

RSpec.describe User, type: :model do
  it "有効なファクトリを持つこと" do
    expect(build(:user)).to be_valid
  end

  it "アカウント名がなければ無効であること" do
    user = build(:user, account_name: nil)
    user.valid?
    expect(user.errors[:account_name]).to include("が入力されていません")
  end

  it "emailがなければ無効であること" do
    user = build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("が入力されていません")
  end

  it "passwordがなければ無効であること" do
    user = build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).to include("が入力されていません")
  end

  it "passwordが5文字以内だと無効であること" do
    user = build(:user, password: "a" * 5)
    user.valid?
    expect(user.errors[:password]).to include("6文字以上で入力してください")
  end

  it "passwordが6文字以上だと有効であること" do
    user = build(:user, password: "a" * 6)
    user.valid?
    expect(user).to be_valid
  end

  it "アカウント名は重複しないこと" do
    create(:user, account_name: "Test User")
    user = build(:user, account_name: "Test User")
    user.valid?
    expect(user.errors[:account_name]).to include("他のユーザーが使用しています")
  end

  it "emailは重複しないこと" do
    create(:user, email: "test@example.com")
    user = build(:user, email: "test@example.com")
    user.valid?
    expect(user.errors[:email]).to include("既に登録されています")
  end

  it "emailは小文字で保存されること" do
    user = create(:user, email: "Foo@ExAMPle.CoM")
    expect(user.email.downcase).to eq user.reload.email
  end

  it "userを削除すると、紐づくrecordも削除されること" do
    user = create(:user)
    user.records.create!(date: Date.today, m_sbp: 132, m_dbp: 84, m_pulse: 64)
    expect { user.destroy }.to change { Record.count }.by(-1)
  end
end
