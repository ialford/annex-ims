# frozen_string_literal: true

class CannedReportsController < ApplicationController
  before_action :set_report, only: %i[show export run export]

  # GET /reports
  # GET /reports.json
  def index
    @reports = CannedReport.all
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    @report.load
    @results = []
    @params = params || []
    @sql = ''
  end

  def export
    output = @report.run(params)

    @results = output[:results]
    @sql = output[:sql]

    headers['Content-Disposition'] = \
      "attachment; filename=\"#{@report.name}.csv\""
    headers['Content-Type'] ||= 'text/csv'

    render 'export.csv'
  end

  def run
    output = @report.run(params)

    @params = params || []
    @errors = output[:errors]
    @results = output[:results]
    @sql = output[:sql]

    render 'show'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_report
    @report = CannedReport.new(params[:id])
    @report.load
  end

  # Never trust parameters from the scary internet.
  def report_params
    params.require(:canned_report)
  end
end
