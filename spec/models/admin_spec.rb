require 'rails_helper'

RSpec.describe Admin, type: :model do
  it "有効なファクトリを持つこと" do
    expect(build(:admin)).to be_valid
  end

  it "アカウント名がなければ無効であること" do
    user = build(:admin, account_name: nil)
    user.valid?
    expect(user.errors[:account_name]).to include("が入力されていません")
  end

  it "emailがなければ無効であること" do
    user = build(:admin, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("が入力されていません")
  end

  it "passwordがなければ無効であること" do
    user = build(:admin, password: nil)
    user.valid?
    expect(user.errors[:password]).to include("が入力されていません")
  end

  it "passwordが5文字以内だと無効であること" do
    user = build(:admin, password: "a" * 5, password_confirmation: "a" * 5)
    user.valid?
    expect(user.errors[:password]).to include("6文字以上で入力してください")
  end

  it "passwordが6文字以上だと有効であること" do
    user = build(:admin, password: "a" * 6, password_confirmation: "a" * 6)
    user.valid?
    expect(user).to be_valid
  end

  it "アカウント名は重複しないこと" do
    create(:admin, account_name: "Test User")
    user = build(:admin, account_name: "Test User")
    user.valid?
    expect(user.errors[:account_name]).to include("他のユーザーが使用しています")
  end

  it "emailは重複しないこと" do
    create(:admin, email: "test@example.com")
    user = build(:admin, email: "test@example.com")
    user.valid?
    expect(user.errors[:email]).to include("既に登録されています")
  end

  it "emailは小文字で保存されること" do
    user = create(:admin, email: "Foo@ExAMPle.CoM")
    expect(user.email.downcase).to eq user.reload.email
  end
end
