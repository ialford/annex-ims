# Preview all emails at http://localhost:3000/rails/mailers/canned_report
class CannedReportPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/canned_report/scheduled
  def scheduled
    CannedReportMailer.scheduled
  end

  # Preview this email at http://localhost:3000/rails/mailers/canned_report/ad_hoc
  def ad_hoc
    CannedReportMailer.ad_hoc
  end

end
