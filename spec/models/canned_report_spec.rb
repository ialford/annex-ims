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

    it 'should generate sql for all shelves of types BH and BL' do
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

    it 'should generate sql properly for a checkbox true (and a date range)' do
      sql = "SELECT DATE(a.action_timestamp at time zone 'UTC' at time zone 'US/East-Indiana'), a.username, SUBSTR(a.data->'tray'->>'barcode',6,2) AS tray_type, COUNT ( DISTINCT CASE WHEN d.data IS NULL AND a.data->'tray'->>'shelf_id' IS NULL THEN a.id WHEN d.data IS NOT NULL THEN NULL END ) AS NEW_INGEST, COUNT ( DISTINCT CASE WHEN d.data IS NULL AND a.data->'tray'->>'shelf_id' IS NOT NULL THEN a.id WHEN d.data IS NOT NULL THEN NULL END ) AS NEW_BACKFILL, COUNT( DISTINCT CASE WHEN d.data IS NULL THEN NULL WHEN d.data IS NOT NULL THEN a.id END ) AS CONSOLIDATE, COUNT(DISTINCT a.id) AS ALL_ITEMS FROM activity_logs a LEFT JOIN activity_logs d ON ( d.data->'item'->>'barcode' = a.data->'item'->>'barcode' AND date(a.action_timestamp) > date(d.action_timestamp) AND a.action = 'AssociatedItemAndTray' AND d.action = 'DissociatedItemAndTray' ) WHERE a.action = 'AssociatedItemAndTray' AND DATE(a.action_timestamp at time zone 'UTC' at time zone 'US/East-Indiana') BETWEEN '" + Time.zone.today.beginning_of_day.strftime('%Y-%m-%d %H:%M:%S') + "' AND '" + Time.zone.today.end_of_day.strftime('%Y-%m-%d %H:%M:%S') + "' GROUP BY a.username, SUBSTR(a.data->'tray'->>'barcode',6,2), DATE(a.action_timestamp at time zone 'UTC' at time zone 'US/East-Indiana')"

      report = CannedReport.new('item_ingest_and_consolidation')
      report.load

      params = {
        'tray_types' => '1',
        'preset_date_range' => 'current_day'
      }
      result = report.run(params)

      expect(result[:errors]).to be_empty
      expect(result[:sql]).to eq(sql)
    end

    it 'should generate sql properly for a checkbox false (and a date range)' do
      sql = "SELECT DATE(a.action_timestamp at time zone 'UTC' at time zone 'US/East-Indiana'), a.username, COUNT ( DISTINCT CASE WHEN d.data IS NULL AND a.data->'tray'->>'shelf_id' IS NULL THEN a.id WHEN d.data IS NOT NULL THEN NULL END ) AS NEW_INGEST, COUNT ( DISTINCT CASE WHEN d.data IS NULL AND a.data->'tray'->>'shelf_id' IS NOT NULL THEN a.id WHEN d.data IS NOT NULL THEN NULL END ) AS NEW_BACKFILL, COUNT( DISTINCT CASE WHEN d.data IS NULL THEN NULL WHEN d.data IS NOT NULL THEN a.id END ) AS CONSOLIDATE, COUNT(DISTINCT a.id) AS ALL_ITEMS FROM activity_logs a LEFT JOIN activity_logs d ON ( d.data->'item'->>'barcode' = a.data->'item'->>'barcode' AND date(a.action_timestamp) > date(d.action_timestamp) AND a.action = 'AssociatedItemAndTray' AND d.action = 'DissociatedItemAndTray' ) WHERE a.action = 'AssociatedItemAndTray' AND DATE(a.action_timestamp at time zone 'UTC' at time zone 'US/East-Indiana') BETWEEN '" + Time.zone.today.beginning_of_week(:monday).beginning_of_day.strftime('%Y-%m-%d %H:%M:%S') + "' AND '" + Time.zone.today.end_of_day.strftime('%Y-%m-%d %H:%M:%S') + "' GROUP BY a.username, DATE(a.action_timestamp at time zone 'UTC' at time zone 'US/East-Indiana')"

      report = CannedReport.new('item_ingest_and_consolidation')
      report.load

      params = {
        'tray_types' => '0',
        'preset_date_range' => 'current_week'
      }
      result = report.run(params)

      expect(result[:errors]).to be_empty
      expect(result[:sql]).to eq(sql)
    end

    it 'should generate sql properly for a number field' do
      sql = "SELECT shelf, size, tray, COUNT(item) AS \"items\", SUM(thickness) AS \"width\", tt.capacity AS \"capacity\", TRUNC(SUM(thickness)/tt.capacity::decimal * 100,2) AS \"percent full\"\nFROM (\n SELECT shelves.barcode AS \"shelf\", shelves.size AS \"size\", trays.barcode AS \"tray\", items.barcode AS \"item\", items.thickness\n FROM shelves INNER JOIN trays ON shelves.id = trays.shelf_id\n LEFT JOIN items ON trays.id = items.tray_id\n) stocked_items\nINNER JOIN tray_types tt ON size = tt.code\n\nGROUP BY shelf, size, tray, tt.capacity\nHAVING SUM(thickness)/tt.capacity::decimal * 100 < 85"

      report = CannedReport.new('tray_fill')
      report.load

      params = {
        'tray_fill' => '85'
      }
      result = report.run(params)

      expect(result[:errors]).to be_empty
      expect(result[:sql]).to eq(sql)
    end
  end
end
