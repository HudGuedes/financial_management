class Charge < ApplicationRecord
  belongs_to :payment_plan
  has_many :payments, dependent: :destroy

  enum payment_method: { boleto: 0, pix: 1 }
  enum status: { emitida: 0, paga: 1, cancelada: 2 }

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :due_date, presence: true
  validates :payment_method, presence: true
  validates :status, presence: true

  before_create :generate_payment_code
  after_save :update_payment_plan_total

  scope :overdue, -> { where('due_date < ? AND status = ?', Date.today, statuses[:emitida]) }
  scope :paid, -> { where(status: :paga) }
  scope :cancelled, -> { where(status: :cancelada) }


  def overdue?
    emitida? && due_date < Date.today
  end

  def current_status
    return 'vencida' if overdue?
    status
  end

  def register_payment!(amount:, payment_date: Date.today, notes: nil)
    raise 'Não é permitido registrar pagamento em cobrança cancelada' if cancelada?

    transaction do
      payments.create!(
        amount: amount,
        payment_date: payment_date,
        notes: notes
      )

      update!(status: :paga)
    end
  end

  private

  def generate_payment_code
    self.payment_code = if boleto?
      "#{Time.now.to_i}#{rand(1000..9999)}.#{rand(10000..99999)} #{rand(10000..99999)}.#{rand(100000..999999)}"
    else
      "PIX#{SecureRandom.hex(16).upcase}"
    end
  end

  def update_payment_plan_total
    payment_plan.recalculate_total! if payment_plan.present?
  end
end
