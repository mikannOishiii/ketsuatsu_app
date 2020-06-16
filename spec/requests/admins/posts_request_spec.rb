require 'rails_helper'

RSpec.describe "Admins::Posts", type: :request do
  let!(:admin) { create(:admin) }
  let!(:post1) { create(:post, title: "mytitle1", content: "mycontent1", admin: admin) }
  let!(:post2) { create(:post, title: "mytitle2", content: "mycontent2", admin: admin) }

  describe "GET #index" do
    context "ログインしていない場合" do
      before do
        get admins_posts_url
      end

      it "リクエストが成功すること" do
        expect(response.status).to eq 302
      end

      it "リダイレクトされること" do
        expect(response).to redirect_to new_admin_session_url
      end
    end

    context "ログインしている場合" do
      before do
        sign_in admin
        get admins_posts_url
      end

      it "リクエストが成功すること" do
        expect(response.status).to eq 200
      end

      it "記事タイトルが表示されていること" do
        expect(response.body).to include "mytitle1"
        expect(response.body).to include "mytitle2"
      end
    end
  end

  describe "GET #new" do
    context "ログインしていない場合" do
      before do
        get new_admins_post_url
      end

      it "リクエストが成功すること" do
        expect(response.status).to eq 302
      end

      it "リダイレクトされること" do
        expect(response).to redirect_to new_admin_session_url
      end
    end

    context "ログインしている場合" do
      before do
        sign_in admin
        get new_admins_post_url
      end

      it "リクエストが成功すること" do
        expect(response.status).to eq 200
      end
    end
  end

  describe "GET #edit" do
    context "ログインしていない場合" do
      before do
        get edit_admins_post_url(post1)
      end

      it "リクエストが成功すること" do
        expect(response.status).to eq 302
      end

      it "リダイレクトされること" do
        expect(response).to redirect_to new_admin_session_url
      end
    end

    context "ログインしている場合" do
      before do
        sign_in admin
        get edit_admins_post_url(post1)
      end

      it "リクエストが成功すること" do
        expect(response.status).to eq 200
      end
    end
  end

  describe "POST #create" do
    before do
      sign_in admin
    end

    context "パラメータが妥当な場合（画像つき）" do
      it "投稿・画像が登録されること" do
        params = { pictures_attributes: [ attributes_for(:picture) ] }
        expect {
          post admins_posts_url, params: { post: attributes_for(:post).merge(params) }
        }.to change(Post, :count).by(1).and change(Picture, :count).by(1)
      end
    end

    context "パラメータが妥当な場合" do
      it "リクエストが成功すること" do
        post admins_posts_url, params: { post: attributes_for(:post) }
        expect(response.status).to eq 302
      end

      it "投稿が登録されること" do
        expect do
          post admins_posts_url, params: { post: attributes_for(:post) }
        end.to change(Post, :count).by(1)
      end

      it "リダイレクトされること" do
        post admins_posts_url, params: { post: attributes_for(:post) }
        expect(response).to redirect_to admins_dashboard_url
      end
    end

    context "パラメータが不正な場合" do
      it "リクエストが成功すること" do
        post admins_posts_url, params: { post: attributes_for(:post, :invalid) }
        expect(response.status).to eq 200
      end

      it "投稿は登録されないこと" do
        expect do
          post admins_posts_url, params: { post: attributes_for(:post, :invalid) }
        end.not_to change(Post, :count)
      end

      it "エラーが表示されること" do
        post admins_posts_url, params: { post: attributes_for(:post, :invalid) }
        expect(response.body).to include "Titleを入力してください"
      end
    end
  end

  describe "PATCH #update" do
    before do
      sign_in admin
    end

    context "パラメータが妥当な場合" do
      it "リクエストが成功すること" do
        put admins_post_url post1, params: { post: attributes_for(:post) }
        expect(response.status).to eq 302
      end

      it "内容が更新されること" do
        expect do
          put admins_post_url post1, params: { post: attributes_for(:post) }
        end.to change { Post.find(post1.id).title }.from("mytitle1").to("MyTitle")
      end

      it "リダイレクトすること" do
        put admins_post_url post1, params: { post: attributes_for(:post) }
        expect(response).to redirect_to admins_dashboard_url
      end
    end

    context "パラメータが不正な場合" do
      it "リクエストが成功すること" do
        put admins_post_url post1, params: { post: attributes_for(:post, :invalid) }
        expect(response.status).to eq 200
      end

      it "内容が変更されないこと" do
        expect do
          put admins_post_url post1, params: { post: attributes_for(:post, :invalid) }
        end.not_to change(Post.find(post1.id), :title)
      end

      it "エラーが表示されること" do
        put admins_post_url post1, params: { post: attributes_for(:post, :invalid) }
        expect(response.body).to include "Titleを入力してください"
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      sign_in admin
    end

    it "リクエストが成功すること" do
      delete admins_post_url post1
      expect(response.status).to eq 302
    end

    it "投稿が削除されること" do
      expect do
        delete admins_post_url post1
      end.to change(Post, :count).by(-1)
    end

    it "リダイレクトすること" do
      delete admins_post_url post1
      expect(response).to redirect_to admins_dashboard_url
    end
  end
end
