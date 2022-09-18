class ScheduledReportsController < ApplicationController
  before_action :set_scheduled_report, only: %i[show edit update destroy]

  # GET /scheduled_reports
  # GET /scheduled_reports.json
  def index
    @scheduled_reports = ScheduledReport.all
  end

  # GET /scheduled_reports/1
  # GET /scheduled_reports/1.json
  def show
  end

  # GET /scheduled_reports/new
  def new
    @scheduled_report = ScheduledReport.new
  end

  # GET /scheduled_reports/1/edit
  def edit
  end

  # POST /scheduled_reports
  # POST /scheduled_reports.json
  def create
    @scheduled_report = ScheduledReport.new(scheduled_report_params)

    respond_to do |format|
      if @scheduled_report.save
        format.html { redirect_to @scheduled_report, notice: 'Scheduled report was successfully created.' }
        format.json { render :show, status: :created, location: @scheduled_report }
      else
        format.html { render :new }
        format.json { render json: @scheduled_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scheduled_reports/1
  # PATCH/PUT /scheduled_reports/1.json
  def update
    respond_to do |format|
      if @scheduled_report.update(scheduled_report_params)
        format.html { redirect_to @scheduled_report, notice: 'Scheduled report was successfully updated.' }
        format.json { render :show, status: :ok, location: @scheduled_report }
      else
        format.html { render :edit }
        format.json { render json: @scheduled_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scheduled_reports/1
  # DELETE /scheduled_reports/1.json
  def destroy
    @scheduled_report.destroy
    respond_to do |format|
      format.html { redirect_to scheduled_reports_url, notice: 'Scheduled report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scheduled_report
      @scheduled_report = ScheduledReport.find(params[:id])
    end

    def allowed_keys
      report = CannedReport.new(params[:canned_report_id])
      report.load
      keys = %i[email id]
      report.contents['parameters'].each do |param|
        keys << if param['type'] == 'multi-select'
                  { param['name'].to_sym => [] }
                else
                  param['name'].to_sym
                end
      end
      keys
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def scheduled_report_params
      report_params = params.permit(allowed_keys)
      report_params[:id] = params[:canned_report_id]
      params[:params] = report_params
      params[:params].delete(:canned_report_id)
      schedule = { rrules: [RecurringSelect.dirty_hash_to_rule(JSON.parse(params[:schedule])).to_hash] }
      params[:schedule] = schedule
      params.permit(:canned_report_id, :email, :nickname, schedule: {}, params: {})
    end
end
