FactoryBot.define do
  factory :user do
    name { "Elías Nevárez Rosales" }
    email { "PBR161216L4A@tmp.com" }
    rfc { "PBR161216L4A" }
    password {'123123'}
    password_confirmation {'123123'}
  end
end
