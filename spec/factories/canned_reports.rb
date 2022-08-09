# frozen_string_literal: true

FactoryBot.define do
  factory :canned_report do
    id 'test_report'
    initialize_with { new(id) }
  end
end
