FactoryBot.define do
  factory :invoice do
    invoice_uid { "74678cbb-ee1c-43fc-86a3-03c2c92da51b" }
    status { "ACTIVE" }
    emitter_id {}
    receiver_id {}
    amount_cents { 15000 }
    amount_currency { "MXP" }
    emitted_at { "2022-09-10 15:30:52" }
    expires_at { "2022-09-10 15:30:52" }
    signed_at { "2022-09-10 15:30:52" }
    cfdi_digital_stamp { "1rom6yhevxn871ffdnjtiwpx3kva00iq8kdn5dcbm8nzsxs6y4xx0v3mh94evef3lecdwxyxyzkhvgywxi1lwzpbztkrhl8ccr3jh456l1ixbghi57rnid9q1dps5pka3ev1nqgagm1z4rmy73vnstskb7gxcvjjd6qum19jv6j7c1fxleqzfkt6u0ev5c2yk8u2a25utjisxpdu74ycz0hogarz5jc0x1sw9o3j9gbsc0n1ajat3ph91vk5654" }
  end
end
