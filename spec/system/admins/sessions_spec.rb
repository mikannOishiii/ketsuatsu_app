require 'rails_helper'

RSpec.feature "Admin::Sessions", type: :system do
  let(:admin) { create(:admin) }

  scenario "ログインに失敗する" do
    visit new_admin_session_path
    fill_in "アカウント名", with: admin.account_name
    fill_in "メールアドレス", with: admin.email
    fill_in "パスワード", with: ""
    click_button "ログイン"
    expect(page).to have_content "アカウント名またはパスワードが違います。"
    expect(current_path).to eq new_admin_session_path
  end

  scenario "ログイン・ログアウトに成功する" do
    visit new_admin_session_path
    fill_in "アカウント名", with: admin.account_name
    fill_in "メールアドレス", with: admin.email
    fill_in "パスワード", with: admin.password
    click_button "ログイン"
    expect(page).to have_content "ログインしました。"
    expect(page).to have_selector "a.nav-link", text: "ログアウト"
    expect(current_path).to eq admins_dashboard_path
    click_link "ログアウト"
    expect(page).to have_content "ログアウトしました。"
    expect(current_path).to eq new_admin_session_path
  end
end
