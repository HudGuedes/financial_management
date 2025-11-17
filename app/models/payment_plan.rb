class PaymentPlan < ApplicationRecord
  belongs_to :guardian
  belongs_to :cost_center
  has_many :charges, dependent: :destroy

  validates :guardian, presence: true
  validates :cost_center, presence: true

  after_save :calculate_total_amount_if_needed

  accepts_nested_attributes_for :charges

  def calculate_total_amount
    total = charges.reload.sum(:amount)
    update_column(:total_amount, total) if total_amount != total
  end

  def calculate_total_amount_if_needed
    calculate_total_amount if charges.any?
  end

  def recalculate_total!
    calculate_total_amount
  end
end
