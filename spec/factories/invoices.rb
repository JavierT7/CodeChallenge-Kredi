FactoryBot.define do
  factory :invoice do
    invoice_uid { "MyString" }
    status { "MyString" }
    emitter_id { 1 }
    receiver_id { 1 }
    amount_cents { 1 }
    amount_currency { "MyString" }
    emitted_at { "2022-09-10 15:30:52" }
    expires_at { "2022-09-10 15:30:52" }
    signed_at { "2022-09-10 15:30:52" }
    cfdi_digital_stamp { "MyString" }
  end
end
