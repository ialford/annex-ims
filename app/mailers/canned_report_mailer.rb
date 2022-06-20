class CannedReportMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.canned_report_mailer.scheduled.subject
  #
  def scheduled
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.canned_report_mailer.ad_hoc.subject
  #
  def ad_hoc(params:)
    @greeting = "Hi"

    mail to: params[:email]
  end
end
