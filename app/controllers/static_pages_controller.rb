class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @user = current_user
      @records = @user.records.current_month
      default_day = Time.now
      if @user.records.exists?(date: default_day)
        @record = @user.records.find_by(date: default_day)
      else
        flash.now[:danger] = 'errored!'
        @record = Record.new(date: default_day)
      end
    end
  end

  def terms
  end
end
