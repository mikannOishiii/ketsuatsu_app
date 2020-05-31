require 'rails_helper'

RSpec.feature "UserEdit", type: :feature do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  scenario "プロフィール編集に失敗する" do
    visit root_path
    click_on "プロフィール編集"
    fill_in "user_account_name", with: "hogehoge"
    fill_in "user_current_password", with: ""
    click_on "Update"

    expect(page).to have_css "#error-explanation"
  end

  scenario "プロフィール編集に成功する" do
    visit root_path
    click_on "プロフィール編集"
    fill_in "user_account_name", with: "hogehoge"
    fill_in "user_current_password", with: user.password
    click_on "Update"

    expect(current_path).to eq account_profile_edit_path
    expect(page).to have_content "アカウント情報を変更しました。"
  end

  scenario "パスワード変更に失敗する" do
    visit root_path
    click_on "プロフィール編集"
    click_on "パスワード変更"
    fill_in "user_password", with: "foobaz"
    fill_in "user_password_confirmation", with: "foobar"
    fill_in "user_current_password", with: user.password
    click_on "Update"

    expect(page).to have_css "#error-explanation"
  end

  scenario "パスワード変更に成功する" do
    visit root_path
    click_on "プロフィール編集"
    click_on "パスワード変更"
    fill_in "user_password", with: "foobaz"
    fill_in "user_password_confirmation", with: "foobaz"
    fill_in "user_current_password", with: user.password
    click_on "Update"

    expect(current_path).to eq account_profile_edit_path
    expect(page).to have_content "アカウント情報を変更しました。"
  end
end
