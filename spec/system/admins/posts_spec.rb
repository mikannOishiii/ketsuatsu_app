require 'rails_helper'

RSpec.feature "Admins::Posts", type: :system do
  let(:admin) { create(:admin) }

  scenario "投稿に成功する" do
    sign_in admin
    visit admins_dashboard_path
    click_link "記事を書く"
    fill_in "post_title", with: "MyTitle hogehoge"
    fill_in "post_content", with: "MyContent hogehoge"
    click_button "投稿する"
    expect(page).to have_content "記事を投稿しました！"
    expect(current_path).to eq admins_dashboard_path
  end

  scenario "投稿に失敗する" do
    sign_in admin
    visit admins_dashboard_path
    click_link "記事を書く"
    fill_in "post_title", with: ""
    fill_in "post_content", with: "MyContent hogehoge"
    click_button "投稿する"
    expect(page).to have_content "Titleを入力してください"
  end
end
