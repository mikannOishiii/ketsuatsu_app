require 'rails_helper'

RSpec.describe "Articles", type: :request do
  let(:user) { create(:user) }
  let(:post1) { create(:post, title: "title1") }
  let(:post2) { create(:post, title: "title2") }
  let(:post3) { create(:post, title: "title3") }

  describe 'GET #index' do
    before do
      sign_in user
      post1.mark_as_read! for: user
      get articles_url
    end

    it "リクエストが成功すること" do
      expect(response.status).to eq 200
    end

    it "@unread_articles（未読記事）が取得できていること" do
      within ".unread_articles" do
        expect(response.body).to include post1.title
      end
    end

    it "@read_articles（既読記事）が取得できていること" do
      within ".read_articles" do
        expect(response.body).to include post2.title, post3.title
      end
    end
  end

  describe 'GET #show' do
    before do
      sign_in user
      get article_url(post1)
    end

    it "リクエストが成功すること" do
      expect(response.status).to eq 200
    end

    it "@articleが取得できていること" do
      expect(response.body).to include post1.title
      expect(response.body).to include post1.content
    end
  end
end
