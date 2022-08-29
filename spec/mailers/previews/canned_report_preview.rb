# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/canned_report
class CannedReportPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/canned_report/email
  def email
    CannedReportMailer.email
  end
end
