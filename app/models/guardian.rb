class Guardian < ApplicationRecord
  has_many :payment_plans, dependent: :destroy
  has_many :charges, through: :payment_plans

  validates :name, presence: true
  validates :cpf, uniqueness: true, allow_blank: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  def total_charges_count
    charges.count
  end
end
