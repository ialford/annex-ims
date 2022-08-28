FactoryBot.define do
  factory :scheduled_report do
    canned_report
    email "MyString"
    params { {}.to_json }
    last_run_at "2022-08-28 14:43:06"
    cancel "MyString"
    schedule "MyString"
  end
end
