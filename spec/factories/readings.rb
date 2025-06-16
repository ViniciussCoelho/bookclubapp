FactoryBot.define do
  factory :reading do
    club { nil }
    title { "MyString" }
    author { "MyString" }
    total_pages { 1 }
    start_date { "2025-06-09" }
    end_date { "2025-06-09" }
    current_reading { false }
    description { "MyText" }
  end
end
