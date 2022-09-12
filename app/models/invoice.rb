class Invoice < ApplicationRecord
  INVOICE_STATUSES = ['ACTIVE', 'VOID', 'PAID', 'NOT PAID']
  INVOICE_TYPES = ['ALL','RECEIVED', 'EMITTED']

  validate :emitter_and_receiver_difference
  validates_uniqueness_of :invoice_uid
  validates_presence_of :invoice_uid

  belongs_to :emitter, class_name: 'User', foreign_key: :emitter_id
  belongs_to :receiver, class_name: 'User', foreign_key: :receiver_id

  delegate :name, to: :emitter, prefix: true
  delegate :name, to: :receiver, prefix: true

  scope :f_by_status, ->(status) { where(status: status) if status.present?}
  scope :f_by_emitter, ->(emitter) { includes(:emitter).where(emitter: emitter) if emitter.present?}
  scope :f_by_receiver, ->(receiver) { includes(:emitter).where(receiver: receiver) if receiver.present?}
  scope :f_by_min_emitted_at, ->(min_emitted_at) { where(emitted_at: min_emitted_at..) if min_emitted_at.present?}
  scope :f_by_max_emitted_at, ->(max_emitted_at) { where(emitted_at: ..max_emitted_at) if max_emitted_at.present?}
  scope :f_by_type, ->(type, user_id) {
    if type == 'RECEIVED'
      where(receiver: user_id)
    elsif type == 'EMITTED'
      where(emitter: user_id)
    end
  }
  scope :min_amount, ->(min) { where(amount_cents: min..) if min.present?}
  scope :max_amount, ->(max) { where(amount_cents: ..max) if max.present?}

  def emitter_and_receiver_difference
    if self.emitter_id == self.receiver_id
      errors.add(:emitter_id, 'must be different to receiver')
      errors.add(:receiver_id, 'must be different to emitter')
    end
  end
end
