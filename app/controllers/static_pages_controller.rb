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
      # カラムの配列
      @dates = @user.records.pluck(:date)
      @m_sbp = @user.records.pluck(:m_sbp)
      @m_dbp = @user.records.pluck(:m_dbp)
      @m_pulse = @user.records.pluck(:m_pulse)
      @n_sbp = @user.records.pluck(:n_sbp)
      @n_dbp = @user.records.pluck(:n_dbp)
      @n_pulse = @user.records.pluck(:n_pulse)
      # 平均値
      @m_sbp_avg = @m_sbp.sum / @m_sbp.length
      @m_dbp_avg = @m_dbp.sum / @m_dbp.length
      @m_pulse_avg = @m_pulse.sum / @m_pulse.length
      @n_sbp_avg = @n_sbp.sum / @n_sbp.length
      @n_dbp_avg = @n_dbp.sum / @n_sbp.length
      @n_pulse_avg = @n_pulse.sum / @n_pulse.length
    end
  end

  def terms
  end


end
