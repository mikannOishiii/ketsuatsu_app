class StaticPagesController < ApplicationController
  before_action :authenticate, only: [:export]

  def home
    if user_signed_in?
      @records = current_user.records.current_month.order(:date)
    end
  end

  def terms
  end

  def export
    @records = current_user.records.last_month

    respond_to do |format|
      format.html
      format.csv do
        export_data_csv(@records)
      end
      format.pdf do
        render pdf: 'sample', # pdfファイルの名前
               layout: 'pdf.html', # views/layouts
               template: 'static_pages/export.html.erb', # テンプレ指定
               encording: 'UTF-8'
      end
    end
  end

  def export_data_csv(records)
    csv_data = CSV.generate do |csv|
      column_names = %w(date m_sbp m_dbp m_pulse n_sbp n_dbp n_pulse memo)
      csv << column_names
      records.each do |record|
        column_values = [
          record.date,
          record.m_sbp,
          record.m_dbp,
          record.m_pulse,
          record.n_sbp,
          record.n_dbp,
          record.n_pulse,
          record.memo,
        ]
        csv << column_values
      end
    end
    send_data(csv_data, filename: "#{Time.zone.now.strftime('%Y%m%d')}.csv")
  end

  def select_date
    if params[:date_range] == "current_month"
      current_month
    elsif params[:date_range] == "last_month"
      last_month
    elsif params[:date_range] == "last_week"
      last_week
    end
  end
end
