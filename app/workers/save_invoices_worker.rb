class SaveInvoicesWorker
  include Sidekiq::Worker

  def perform(hash_data)
    user_emitter  = User.find_by(rfc: hash_data["emitter"]['rfc'])
    user_receiver = User.find_by(rfc: hash_data["receiver"]['rfc'])
    unless user_emitter.present?
      user_emitter = User.create!(name: hash_data["emitter"]['name'], rfc: hash_data["emitter"]['rfc'], email: "#{hash_data["emitter"]['rfc']}@tmp.mx", password:'tmp_pwd', password_confirmation: 'tmp_pwd')
    end
    unless user_receiver.present?
      user_receiver = User.create!(name: hash_data["receiver"]['name'], rfc: hash_data["receiver"]['rfc'], email: "#{hash_data["receiver"]['rfc']}@tmp.mx", password:'tmp_pwd', password_confirmation: 'tmp_pwd')
    end
    Invoice.create!(invoice_uid: hash_data["invoice_uuid"], status: hash_data['status'].upcase,emitter_id: user_emitter.id, receiver_id: user_receiver.id, amount_cents: hash_data['amount']['cents'], amount_currency: hash_data['amount']['currency'], emitted_at: hash_data['emitted_at'], expires_at: hash_data['expires_at'], signed_at: hash_data['signed_at'], cfdi_digital_stamp: hash_data['cfdi_digital_stamp'])
  end
end
