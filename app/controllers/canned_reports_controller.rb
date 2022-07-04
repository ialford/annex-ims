# frozen_string_literal: true

class CannedReportsController < ApplicationController
  before_action :set_report, except: %i[index]

  # GET /reports
  # GET /reports.json
  def index
    @reports = CannedReport.all
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    @report.load
    @results = nil
    @params = report_params || []
    @sql = ''
  end

  def export
    output = @report.run(report_params)

    @results = output[:results]
    @sql = output[:sql]

    headers['Content-Disposition'] = \
      "attachment; filename=\"#{@report.name}.csv\""
    headers['Content-Type'] ||= 'text/csv'

    render 'export.csv'
  end

  def run
    output = @report.run(report_params)

    @params = report_params || []
    @errors = output[:errors]
    @results = output[:results]
    @sql = output[:sql]

    render 'show'
  end

  def email
    output = @report.run(report_params)

    @params = report_params || []
    @errors = output[:errors]
    @results = output[:results]
    @sql = output[:sql]

    CannedReportMailer.ad_hoc(params: report_params).deliver_now

    render 'show'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_report
    @report = CannedReport.new(params[:id])
    @report.load
  end

  def allowed_keys
    (@report.contents['parameters'].map { |p| p['name'].to_sym } << %i[email id]).flatten
  end

  # Never trust parameters from the scary internet.
  def report_params
    params.permit(allowed_keys)
  end
end
