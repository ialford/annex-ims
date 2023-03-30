FactoryBot.define do
  factory :request do
    criteria_type 'barcode'
    sequence(:criteria, &:to_s)
    sequence(:barcode) { |n| "12345#{n}" }
    sequence(:trans) { |n| "aleph_12345#{n}" }
    requested Faker::Date.between(from: 2.days.ago, to: Date.today)
    rapid false
    source 'aleph'
    del_type 'loan'
    req_type 'doc_del'
  end
end
