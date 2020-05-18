require 'rails_helper'

RSpec.feature "UserEdit", type: :feature do
  let(:user) { create(:user) }

  def extract_passwordreset_url(mail)
    body = mail.body.encoded
    body[/http[^"]+/]
  end

  scenario "パスワードリセットに成功する" do
    visit login_path
    click_link "パスワードを忘れた人はこちら"

    # メール送信に失敗する
    fill_in "email", with: "invaried@example.com"
    expect { click_button "送信する" }.to change { ActionMailer::Base.deliveries.size }.by(0)
    expect(page).to have_content "エラーが発生したため ユーザ は保存されませんでした。"

    # メール送信に成功する
    fill_in "email", with: user.email
    expect { click_button "送信する" }.to change { ActionMailer::Base.deliveries.size }.by(1)
    expect(page).to have_content "パスワードの再設定について数分以内にメールでご連絡いたします。"

    mail = ActionMailer::Base.deliveries.last
    expect(mail.body.encoded).to have_content "パスワードをリセットする"
    url = extract_passwordreset_url(mail)
    visit url
    expect(page).to have_content "パスワードリセット"

    # パスワードリセットに失敗する
    fill_in "パスワード", with: "foobaz"
    fill_in "パスワード（確認用）", with: "barbaz"
    click_button "パスワードをリセット"
    expect(page).to have_content "パスワード（確認用）とパスワードの入力が一致しません"

    # パスワードリセットに成功する
    fill_in "パスワード", with: "foobaz"
    fill_in "パスワード（確認用）", with: "foobaz"
    click_button "パスワードをリセット"
    expect(page).to have_content "パスワードが正しく変更されました。"
  end
end
