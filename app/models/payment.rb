class Payment < ApplicationRecord
  belongs_to :charge

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :payment_date, presence: true
  validates :charge, presence: true
end
