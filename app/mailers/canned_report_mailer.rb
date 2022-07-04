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
    @greeting = 'Hi'
    @report_name = params[:id].titleize

    report = CannedReport.new(params[:id])
    report.load
    results = report.run(params)

    tempfile = Tempfile.new(['canned_report_mailer', '.csv']).tap do |fh|
      csv = CSV.open(fh, 'wb')
      csv << results[:results].first.keys.map(&:titleize)
      results[:results].each do |result|
        row = []
        result.each do |_key, value|
          row << value&.to_s&.gsub('"', '')
        end

        csv << row
      end
    end

    run_time = Time.now.strftime('%Y_%m_%d_%H_%M_%S')

    attachments["#{params[:id]}_#{run_time}.csv"] = tempfile.read
    mail to: params[:email], subject: "Canned Report: #{params[:id]}"

    tempfile.unlink
  end
end
