# frozen_string_literal: true

class CannedReportMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.canned_report_mailer.scheduled.subject
  #
  def scheduled
    @greeting = 'Hi'

    mail to: 'to@example.org'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.canned_report_mailer.ad_hoc.subject
  #
  def ad_hoc(params:)
    @report_name = params[:id].titleize
    @params = params

    report = CannedReport.new(params[:id])
    report.load
    results = report.run(params)

    tempfile = Tempfile.new(['canned_report_mailer', '.csv']).tap do |fh|
      csv = CSV.open(fh, 'wb')
      unless results[:results].empty?
        csv << results[:results].first.keys.map(&:titleize)
        results[:results].each do |result|
          row = []
          result.each do |_key, value|
            row << value&.to_s&.gsub('"', '')
          end

          csv << row
        end
      end
    end

    run_time = Time.now
    run_time_file = run_time.strftime('%Y_%m_%d_%H_%M_%S')
    filename = "#{@report_name}_#{run_time_file}.csv"

    @run_time_text = run_time.strftime('%Y-%m-%d %H:%M:%S')

    attachments[filename] = tempfile.read
    mail to: params[:email], subject: "Canned Report: #{params[:id]}"

    tempfile.unlink
  end
end
