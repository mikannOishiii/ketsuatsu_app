require 'rails_helper'

RSpec.describe "Admins::Posts", type: :request do
  let!(:admin) { create(:admin) }
  let!(:post1) { create(:post, title: "mytitle1", content: "mycontent1", admin: admin) }
  let!(:post2) { create(:post, title: "mytitle2", content: "mycontent2", admin: admin) }

  shared_examples_for "リクエストが成功する（302）" do
    it { expect(response.status).to eq 302 }
  end

  shared_examples_for "リクエストが成功する（200）" do
    it { expect(response.status).to eq 200 }
  end

  shared_examples_for "new_admin_session_urlにリダイレクトされること" do
    it { expect(response).to redirect_to new_admin_session_url }
  end

  shared_examples_for "admins_dashboard_urlにリダイレクトされること" do
    it { expect(response).to redirect_to admins_dashboard_url }
  end

  describe "GET #index" do
    context "ログインしていない場合" do
      before do
        get admins_posts_url
      end

      it_behaves_like "リクエストが成功する（302）"
      it_behaves_like "new_admin_session_urlにリダイレクトされること"
    end

    context "ログインしている場合" do
      before do
        sign_in admin
        get admins_posts_url
      end

      it_behaves_like "リクエストが成功する（200）"

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

      it_behaves_like "リクエストが成功する（302）"
      it_behaves_like "new_admin_session_urlにリダイレクトされること"
    end

    context "ログインしている場合" do
      before do
        sign_in admin
        get new_admins_post_url
      end

      it_behaves_like "リクエストが成功する（200）"
    end
  end

  describe "GET #edit" do
    context "ログインしていない場合" do
      before do
        get edit_admins_post_url(post1)
      end

      it_behaves_like "リクエストが成功する（302）"
      it_behaves_like "new_admin_session_urlにリダイレクトされること"
    end

    context "ログインしている場合" do
      before do
        sign_in admin
        get edit_admins_post_url(post1)
      end

      it_behaves_like "リクエストが成功する（200）"
    end
  end

  describe "POST #create" do
    before do
      sign_in admin
    end

    context "パラメータが妥当な場合（画像つき）" do
      it "投稿・画像が登録されること" do
        params = { pictures_attributes: [attributes_for(:picture)] }
        expect do
          post admins_posts_url, params: { post: attributes_for(:post).merge(params) }
        end.to change(Post, :count).by(1).and change(Picture, :count).by(1)
      end
    end

    context "パラメータが妥当な場合" do
      subject { post admins_posts_url, params: { post: attributes_for(:post) } }

      it { is_expected.to eq 302 }

      it { expect { subject }.to change(Post, :count).by(1) }

      it { is_expected.to redirect_to admins_dashboard_url }
    end

    context "パラメータが不正な場合" do
      subject { post admins_posts_url, params: { post: attributes_for(:post, :invalid) } }

      it { is_expected.to eq 200 }

      it { expect { subject }.not_to change(Post, :count) }

      it "エラーが表示されること" do
        expect(subject)
        expect(response.body).to include "Titleを入力してください"
      end
    end
  end

  describe "PATCH #update" do
    before do
      sign_in admin
    end

    context "パラメータが妥当な場合" do
      subject { put admins_post_url post1, params: { post: attributes_for(:post) } }

      it { is_expected.to eq 302 }

      it { expect { subject }.to change { Post.find(post1.id).title }.from("mytitle1").to("MyTitle") }

      it { is_expected.to redirect_to admins_dashboard_url }
    end

    context "パラメータが不正な場合" do
      subject { put admins_post_url post1, params: { post: attributes_for(:post, :invalid) } }

      it { is_expected.to eq 200 }

      it { expect { subject }.not_to change(Post.find(post1.id), :title) }

      it "エラーが表示されること" do
        expect(subject)
        expect(response.body).to include "Titleを入力してください"
      end
    end
  end

  describe "DELETE #destroy" do
    subject { delete admins_post_url post1 }

    before do
      sign_in admin
    end

    it { is_expected.to eq 302 }

    it { expect { subject }.to change(Post, :count).by(-1) }

    it { is_expected.to redirect_to admins_dashboard_url }
  end
end
