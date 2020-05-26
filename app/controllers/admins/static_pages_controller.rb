class Admins::StaticPagesController < ApplicationController
  before_action :admin_user

  def dashboard
  end
end
