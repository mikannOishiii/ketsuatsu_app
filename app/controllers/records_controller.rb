class RecordsController < ApplicationController
  before_action :authenticate_user!

  def new
    @user = current_user
    default_day = Time.now
    if @user.records.exists?(date: default_day)
      @record = @user.records.find_by(date: default_day)
    else
      flash.now[:danger] = 'errored!'
      @record = Record.new(date: default_day)
    end
  end

  def create
    @record = Record.new(record_params)
    if @record.save
      redirect_to root_url
      flash[:notice] = 'Record was successfully created.'
    else
      flash.now[:danger] = 'errored!'
      render 'new'
    end
  end

  def update
    @user = current_user
    @record = @user.records.find_by(date: params[:record][:date])
    if @record.update_attributes(record_params)
      redirect_to root_url
      flash[:notice] = 'Record was successfully updated.'
    else
      flash.now[:danger] = 'errored!'
      render 'new'
    end
  end

  def search
    @user = current_user
    @record = @user.records.find_by(date: params[:date])
    if @record.nil?
      @record = Record.new
      render json: @record
    else
      render json: @record
    end
  end

  private

  def record_params
    params.require(:record).permit(:date, :m_sbp, :m_dbp, :m_pulse,
                                   :n_sbp, :n_dbp, :n_pulse, :memo,)
                           .merge(user_id: current_user.id)
  end
end
