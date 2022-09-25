class ScheduledReport < ApplicationRecord
  before_validation :set_cancel

  validates :canned_report_id, presence: true
  validates :email, presence: true
  validates :params, presence: true
  validates :cancel, presence: true
  validates :cancel, uniqueness: true
  validates :schedule, presence: true
  validates :name, presence: true
  validates :name, uniqueness: true
  validate :canned_report_exists

  def canned_report
    @canned_report ||= CannedReport.find(canned_report_id)
  end

  def canned_report=(canned_report)
    self.canned_report_id = canned_report.id
  end

  def schedule_humanize
    IceCube::Schedule.from_hash(schedule).to_s
  end

  def schedule_ical
    IceCube::Schedule.from_hash(schedule).to_ical
  end

  def due?
    sched = IceCube::Schedule.from_hash(schedule)
    sched.occurs_between?(last_run_at || created_at, Time.current)
  end

  def run
    sym_params = params.symbolize_keys
    sym_params[:id] = canned_report_id
    sym_params[:name] = name
    sym_params[:email] = email

    CannedReportMailer.email(params: sym_params).deliver_now

    last_run_at = Time.current
    save!
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
