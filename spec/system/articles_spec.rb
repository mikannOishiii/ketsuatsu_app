require 'rails_helper'

RSpec.feature "Articles", type: :system do
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }

  before do
    sign_in user
  end

  scenario "記事を読むと既読になる" do
    post1 = create(:post, title: "title1", admin: admin)
    post2 = create(:post, title: "title2", admin: admin)
    visit root_path
    click_link "コラム"
    within ".unread_articles" do
      expect(page).to have_content "title1"
      expect(page).to have_content "title2"
    end
    click_link "title1"
    expect(page).to have_content "title1"
    expect(page).to have_content post1.content
    click_link "コラム一覧"
    within ".unread_articles" do
      expect(page).to have_content "title2"
      expect(page).not_to have_content "title1"
    end
    within ".read_articles" do
      expect(page).to have_content "title1"
    end
    click_link "title2"
    expect(page).to have_content "title2"
    expect(page).to have_content post2.content
    click_link "コラム一覧"
    within ".unread_articles" do
      expect(page).to have_content "未読の記事はありません。"
      expect(page).not_to have_content "title2"
    end
    within ".read_articles" do
      expect(page).to have_content "title1"
      expect(page).to have_content "title2"
    end
  end
end
