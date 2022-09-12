require 'rails_helper'

RSpec.describe User, type: :model do
  subject{
    described_class.new(name: 'user', email: 'user@tmp.com', rfc:'rfcgod', password: 'password', password_confirmation: 'password')
  }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without rfc' do
    subject.rfc = nil
    expect(subject).to be_invalid
  end
end
