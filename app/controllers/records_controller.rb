class RecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_create_or_update, only: [:create, :update]
  protect_from_forgery except: :destroy # destroyアクションを除外

  def new
    if current_user.records.exists?(date: Time.current)
      @record = current_user.records.find_by(date: Time.current)
    else
      @record = current_user.records.new(date: Time.current)
    end
  end

  def create
  end

  def edit
    @record = current_user.records.find(params[:id])
  end

  def update
  end

  def destroy
    @record = current_user.records.find(params[:id])
    respond_to do |format|
      @record.destroy
      format.html { redirect_to root_url, notice: "記録を削除しました。" }
      format.js
    end
  end

  def search
    @record = current_user.records.find_by(date: params[:date])
    respond_to do |format|
      @record = current_user.records.new(date: params[:date]) if @record.nil?
      format.json { render json: @record }
    end
  end

  def date_range
    if params[:date_range] == "current_month"
      @records = current_user.records.current_month.order(:date)
    elsif params[:date_range] == "last_month"
      @records = current_user.records.last_month.order(:date)
    elsif params[:date_range] == "last_week"
      @records = current_user.records.last_week.order(:date)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def record_params
    params.require(:record).permit(:date, :m_sbp, :m_dbp, :m_pulse, :n_sbp, :n_dbp, :n_pulse, :memo,)
  end

  def set_create_or_update
    @record = current_user.records.find_by(date: params[:record][:date])
    respond_to do |format|
      if @record.nil?
        @record = current_user.records.new(record_params)
        if @record.save
          format.html { redirect_to root_url, notice: "記録を作成しました。" }
        else
          format.js { render :new }
        end
      else
        if @record.update(record_params)
          format.html { redirect_to root_url, notice: "記録を更新しました。" }
        else
          format.js { render :new }
        end
      end
    end
  end
end
