class CostCenter < ApplicationRecord
  has_many :payment_plans, dependent: :restrict_with_error

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true

  before_validation :normalize_code

  private

  def normalize_code
    self.code = code.upcase.strip if code.present?
  end
end
