require 'rails_helper'

RSpec.feature "Registrations", type: :feature do
  let(:user) { create(:user) }

  before do
    visit root_path
  end

  scenario "ログインに失敗しエラー情報を返す", js: true do
    click_on "ログインはこちら"
    within "#nameLogin" do
      fill_in "user_account_name", with: user.account_name
      fill_in "user_password", with: "foo"
      click_on "ログイン"
    end
    expect(page).to have_css "p.alert"
  end

  scenario "ユーザー登録に成功する", js: true do
    click_on "ログインはこちら"
    within "#nameLogin" do
      fill_in "user_account_name", with: user.account_name
      fill_in "user_password", with: user.password
      click_on "ログイン"
    end
    expect(current_path).to eq root_path
    expect(page).to have_content "ログインしました。"
  end
end
