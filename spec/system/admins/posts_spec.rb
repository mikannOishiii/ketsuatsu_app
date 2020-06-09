require 'rails_helper'

RSpec.feature "Admins::Posts", type: :system do
  let!(:admin) { create(:admin) }
  let!(:post1) { create(:post, title: "title1", admin: admin, status: "draft") }
  let!(:post2) { create(:post, title: "title2", admin: admin, status: "published") }
  let!(:post3) { create(:post, title: "title3", admin: admin, status: "unpublished") }

  scenario "投稿に成功する" do
    sign_in admin
    visit admins_dashboard_path
    click_link "記事を書く"
    fill_in "post_title", with: "MyTitle hogehoge"
    fill_in "post_content", with: "MyContent hogehoge"
    select "公開", from: "post[status]"
    click_button "投稿する"
    expect(page).to have_content "記事を投稿しました！"
    expect(current_path).to eq admins_dashboard_path
    click_link "記事管理"
    expect(page).to have_content "MyTitle hogehoge"
    expect(page).to have_content "公開"
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

  scenario "記事を絞り込む", js: true do
    sign_in admin
    visit admins_dashboard_path
    click_link "記事管理"
    expect(page).to have_content post1.title
    expect(page).to have_content post2.title
    expect(page).to have_content post3.title
    # 下書きのみ表示される
    select "下書き中", from: "status"
    click_button "絞込"
    expect(page).to have_content post1.title
    expect(page).not_to have_content post2.title
    expect(page).not_to have_content post3.title
    # 公開記事のみ表示される
    select "公開", from: "status"
    click_button "絞込"
    expect(page).to have_content post2.title
    expect(page).not_to have_content post1.title
    expect(page).not_to have_content post3.title
    # 非公開記事のみ表示される
    select "非公開", from: "status"
    click_button "絞込"
    expect(page).to have_content post3.title
    expect(page).not_to have_content post1.title
    expect(page).not_to have_content post2.title
  end
end
