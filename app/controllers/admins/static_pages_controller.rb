class Admins::StaticPagesController < ApplicationController
  before_action :admin_user

  def dashboard
  end

  protected

  def admin_user
    redirect_to new_admin_session_url unless admin_signed_in?
  end
end
