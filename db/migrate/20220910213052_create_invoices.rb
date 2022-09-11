class CreateInvoices < ActiveRecord::Migration[6.1]
  def change
    create_table :invoices do |t|
      t.string :invoice_uid
      t.string :status
      t.integer :emitter_id
      t.integer :receiver_id
      t.integer :amount_cents
      t.string :amount_currency
      t.datetime :emitted_at
      t.datetime :expires_at
      t.datetime :signed_at
      t.string :cfdi_digital_stamp

      t.timestamps
    end
  end
end
