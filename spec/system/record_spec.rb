require 'rails_helper'

RSpec.feature "Record", type: :system do
  let(:user) { create(:user) }
  let!(:record_yesterday) { create(:record, user: user, date: Time.now.ago(1.days)) }
  let!(:record_lastweek) { create(:record, user: user, date: Time.now.ago(5.days)) }
  let!(:record_lastmonth) { create(:record, user: user, date: Time.now.prev_month.beginning_of_month) }

  before do
    sign_in user
  end

  scenario "新しいデータの登録に失敗する（日付がない場合）", js: true do
    visit root_path
    click_on "記入する"
    sleep 0.5
    fill_in "inputDate", with: ""
    fill_in "inputM_SBP", with: 150
    expect(page).not_to have_content "記録する"
    expect(page).to have_content "日付を入力してください"
  end

  scenario "新しいデータの登録に失敗する（数値以外が入力されている場合）", js: true do
    visit root_path
    click_on "記入する"
    sleep 0.5
    fill_in "inputDate", with: Time.now
    fill_in "inputM_SBP", with: "hoge"
    click_on "記録する"
    sleep 0.5
    expect(page).to have_css ".alert-warning"
  end

  scenario "新しいデータの登録に成功して、編集に成功する、削除に成功する", js: true do
    visit root_path
    click_on "記入する"
    sleep 0.5
    fill_in "inputM_SBP", with: 150
    click_on "記録する"
    sleep 1
    expect(current_path).to eq root_path
    expect(page).to have_content "記録を作成しました。"
    click_on "記入する"
    sleep 0.5
    expect(page).to have_content "150"
    fill_in "inputM_SBP", with: 160
    click_on "記録する"
    sleep 1
    expect(current_path).to eq root_path
    expect(page).to have_content "記録を更新しました。"
    expect(page).to have_content Time.now.strftime("%Y-%m-%d")
    expect(page).to have_content "160"
    click_on "記入する"
    sleep 0.5
    expect(page).to have_content "160"
    page.accept_confirm do
      click_on "削除する"
    end
    expect(current_path).to eq root_path
    expect(page).to have_content "記録を削除しました。"
    expect(page).not_to have_content Time.now.strftime("%Y-%m-%d")
    expect(page).not_to have_content "160"
  end

  scenario "日付を変更して、データを更新する、データを削除する", js: true do
    visit root_path
    click_on "記入する"
    sleep 0.5
    fill_in "inputDate", with: Time.now.yesterday
    expect(page).to have_content record_yesterday.m_sbp
    fill_in "inputM_SBP", with: 155
    click_on "記録する"
    sleep 0.5
    expect(current_path).to eq root_path
    expect(page).to have_content "記録を更新しました。"
    click_on "記入する"
    sleep 0.5
    fill_in "inputDate", with: Time.now.yesterday
    expect(page).to have_content "155"
    page.accept_confirm do
      click_on "削除する"
    end
    expect(current_path).to eq root_path
    expect(page).to have_content "記録を削除しました。"
  end

  scenario "期間切替に成功する", js: true do
    record_today = create(:record, user: user, date: Time.now)
    # 今月のデータが登録されている
    visit root_path
    within "#record-table" do
      expect(page).to have_content record_today.date
      expect(page).not_to have_content record_lastmonth.date
    end
    # 先月のデータが登録されている
    select "先月", from: "date_range"
    click_button "切替"
    within "#record-table" do
      expect(page).to have_content record_lastmonth.date
      expect(page).not_to have_content record_today.date
    end
    # 1週間前までのデータが登録されている
    select "直近一週間", from: "date_range"
    click_button "切替"
    within "#record-table" do
      expect(page).to have_content record_yesterday.date
      expect(page).to have_content record_lastweek.date
      expect(page).not_to have_content record_lastmonth.date
    end
  end
end
