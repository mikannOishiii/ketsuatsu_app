class RecordsController < ApplicationController
  before_action :authenticate_user!
  protect_from_forgery except: :destroy # destroyアクションを除外

  def new
    if current_user.records.exists?(date: Time.now)
      @record = current_user.records.find_by(date: Time.now)
    else
      @record = Record.new(date: Time.now)
    end
  end

  def create
    @record = current_user.records.find_by(date: params[:record][:date])
    respond_to do |format|
      if @record.nil?
        @record = Record.new(record_params)
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

  def edit
    @record = current_user.records.find(params[:id])
  end

  def update
    @record = current_user.records.find_by(date: params[:record][:date])
    respond_to do |format|
      if @record.nil?
        @record = Record.new(record_params)
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
      if @record.nil?
        @record = Record.new(date: params[:date])
        format.json { render json: @record }
      else
        format.json { render json: @record }
      end
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
    params.require(:record).
      permit(:date, :m_sbp, :m_dbp, :m_pulse, :n_sbp, :n_dbp, :n_pulse, :memo,).
      merge(user_id: current_user.id)
  end
end
