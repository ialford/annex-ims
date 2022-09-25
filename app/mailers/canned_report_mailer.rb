# frozen_string_literal: true

class CannedReportMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.canned_report_mailer.email.subject
  #
  def email(params:)
    @name = params[:name].present? ? params[:name] : 'Ad Hoc'

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
      csv.close
    end

    run_time = Time.current
    run_time_file = run_time.strftime('%Y_%m_%d_%H_%M_%S')

    @run_time_text = run_time.strftime('%Y-%m-%d %H:%M:%S')

    attachments["#{params[:id]}_#{run_time_file}.csv"] = tempfile.read

    mail to: params[:email], subject: "Canned Report: #{params[:id]} - #{@run_time_text} on #{Socket.gethostname}"

    tempfile.unlink
  end
end
