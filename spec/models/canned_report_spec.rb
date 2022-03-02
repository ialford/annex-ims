# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CannedReport, type: :model do
  context 'validation' do
    it 'should be valid' do
      expect(CannedReport.new('shelf_report')).to be_valid
    end

    it 'should not be valid' do
      expect(CannedReport.new('')).to_not be_valid
    end
  end

  context 'load' do
    it 'should load the file' do
      report = CannedReport.new('shelf_report')
      report.load
      expect(report.contents).to_not be_nil
    end
  end

  context 'to_sql' do
    it 'should try to generate sql, with an error for a missing required parameter' do
      report = CannedReport.new('shelf_report')
      report.load

      params = {}
      result = report.run(params)
      expect(result[:errors]).to match_array(['Missing required parameter: shelf_limits'])
    end

    it 'should generate sql for all shelves' do
      sql = 'SELECT s.barcode AS "shelf", count (t.id) AS "trays", tt.trays_per_shelf AS "expected" , s.size AS "tray_type" FROM shelves s INNER JOIN trays t ON s.id = t.shelf_id INNER JOIN tray_types tt ON s.size = tt.code GROUP BY s.barcode, tt.trays_per_shelf, s.size'

      report = CannedReport.new('shelf_report')
      report.load

      params = { 'shelf_limits' => 'all' }
      result = report.run(params)

      expect(result[:errors]).to be_empty
      expect(result[:sql]).to eq(sql)
    end

    it 'should generate sql for under capacity shelves' do
      sql = 'SELECT s.barcode AS "shelf", count (t.id) AS "trays", tt.trays_per_shelf AS "expected" , s.size AS "tray_type" FROM shelves s INNER JOIN trays t ON s.id = t.shelf_id INNER JOIN tray_types tt ON s.size = tt.code GROUP BY s.barcode, tt.trays_per_shelf, s.size HAVING count(t.id) < tt.trays_per_shelf'

      report = CannedReport.new('shelf_report')
      report.load

      params = { 'shelf_limits' => 'under_capacity' }
      result = report.run(params)

      expect(result[:errors]).to be_empty
      expect(result[:sql]).to eq(sql)
    end

    it 'should generate sql for over capacity shelves' do
      sql = 'SELECT s.barcode AS "shelf", count (t.id) AS "trays", tt.trays_per_shelf AS "expected" , s.size AS "tray_type" FROM shelves s INNER JOIN trays t ON s.id = t.shelf_id INNER JOIN tray_types tt ON s.size = tt.code GROUP BY s.barcode, tt.trays_per_shelf, s.size HAVING count(t.id) > tt.trays_per_shelf'

      report = CannedReport.new('shelf_report')
      report.load

      params = { 'shelf_limits' => 'over_capacity' }
      result = report.run(params)

      expect(result[:errors]).to be_empty
      expect(result[:sql]).to eq(sql)
    end

    it 'should generate sql for all shelves oof types BH and BL' do
      sql = "SELECT s.barcode AS \"shelf\", count (t.id) AS \"trays\", tt.trays_per_shelf AS \"expected\" , s.size AS \"tray_type\" FROM shelves s INNER JOIN trays t ON s.id = t.shelf_id INNER JOIN tray_types tt ON s.size = tt.code WHERE s.size IN ('BH', 'BL') GROUP BY s.barcode, tt.trays_per_shelf, s.size"

      report = CannedReport.new('shelf_report')
      report.load

      params = {
        'tray_type' => %w[BH BL],
        'shelf_limits' => 'all'
      }
      result = report.run(params)

      expect(result[:errors]).to be_empty
      expect(result[:sql]).to eq(sql)
    end
  end
end
