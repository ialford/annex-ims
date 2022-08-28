class ScheduledReport < ApplicationRecord
  before_validation :set_cancel

  validates :canned_report_id, presence: true
  validates :email, presence: true
  validates :params, presence: true
  validates :cancel, presence: true
  validates :cancel, uniqueness: true
  validates :schedule, presence: true
  validate :canned_report_exists

  def canned_report
    @canned_report ||= CannedReport.find(canned_report_id)
  end

  def canned_report=(canned_report)
    self.canned_report_id = canned_report.id
  end

  private

  def canned_report_exists
    if canned_report.nil?
      errors.add(:canned_report_id, "must be a valid canned report")
    end
  end

  def set_cancel
    self.cancel = Digest::SHA256.hexdigest "#{Time.current}#{Rails.application.secrets.secret_key_base}" if self.cancel.nil?
  end
end
