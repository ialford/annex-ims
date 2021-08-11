# frozen_string_literal: true

class CannedReportsController < ApplicationController
  before_action :set_report, only: %i[show export]

  # GET /reports
  # GET /reports.json
  def index
    @reports = CannedReport.all
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    output = @report.run

    @results = output[:results]
    @sql = output[:sql]

    @report.fields << 'activity'
  end

  def export
    output = @report.run

    @results = output[:results]
    @sql = output[:sql]

    @report.fields << 'activity'

    headers['Content-Disposition'] = \
      "attachment; filename=\"#{@report.name}.csv\""
    headers['Content-Type'] ||= 'text/csv'

    render 'export.csv'
  end

    private

  # Use callbacks to share common setup or constraints between actions.
  def set_report
    @report = CannedReport.new(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def report_params
    preprocess_start_date(params)
    preprocess_end_date(params)

    params.require(:report).permit(:name, :start_date, :end_date, :preset_date_range, :activity, :request_status, :item_status, fields: [])
  end

  def preprocess_start_date(params)
    if params[:report]['start_date(1i)'].present?
      params[:report]['start_date'] = Date.new(
        params[:report]['start_date(1i)'].to_i,
        params[:report]['start_date(2i)'].present? ? params[:report]['start_date(2i)'].to_i : 1,
        params[:report]['start_date(3i)'].present? ? params[:report]['start_date(3i)'].to_i : 1
      ).to_s

      params[:report].delete('start_date(1i)')
      params[:report].delete('start_date(2i)')
      params[:report].delete('start_date(3i)')
    end

    params
  end

  def preprocess_end_date(params)
    if params[:report]['end_date(1i)'].present?
      year = params[:report]['end_date(1i)'].to_i
      month = params[:report]['end_date(2i)'].present? ? params[:report]['end_date(2i)'].to_i : 12
      day = if params[:report]['end_date(3i)'].present? && params[:report]['end_date(3i)'].to_i <= Time.days_in_month(month, year)
              params[:report]['end_date(3i)'].to_i
            else
              Time.days_in_month(month, year)
            end

      params[:report]['end_date'] = Date.new(
        year,
        month,
        day
      ).to_s

      params[:report].delete('end_date(1i)')
      params[:report].delete('end_date(2i)')
      params[:report].delete('end_date(3i)')
    end
    params
  end
  end
