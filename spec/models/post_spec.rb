require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:admin_user) { create(:admin) }

  it "紐づくadminがあれば有効であること" do
    post = build(:post, admin: admin_user)
    expect(post).to be_valid
  end

  it "紐づくadminがなければ無効であること" do
    post = build(:post, admin: nil)
    expect(post).not_to be_valid
  end

  it "titleがなければ無効であること" do
    post = build(:post, admin: admin_user, title: nil)
    expect(post).not_to be_valid
  end

  it "contentがなければ無効であること" do
    post = build(:post, admin: admin_user, content: nil)
    expect(post).not_to be_valid
  end

  it "titleは50文字以内であること" do
    post = build(:post, admin: admin_user, title: "a" * 50)
    expect(post).to be_valid
  end

  it "titleは51文字以上あると無効であること" do
    post = build(:post, admin: admin_user, title: "a" * 51)
    expect(post).not_to be_valid
  end

  it "contentは1,000文字以内であること" do
    post = build(:post, admin: admin_user, content: "a" * 1000)
    expect(post).to be_valid
  end

  it "contentは1,001文字以上あると無効であること" do
    post = build(:post, admin: admin_user, content: "a" * 1001)
    expect(post).not_to be_valid
  end

  it "ユーザーを削除すると記事も削除される" do
    admin_user.posts.create(title: "mytitle", content: "mycontent")
    expect { admin_user.destroy }.to change(Post, :count).by(-1)
  end
end
