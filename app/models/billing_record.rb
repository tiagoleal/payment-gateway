class BillingRecord < ApplicationRecord
  belongs_to :client

  validates :client, presence: true
  validates :billed_at, presence: true
  validates :payment_method_identifier, presence: true
  validates :status, presence: true
  validates :year_month, presence: true, uniqueness: { scope: :client_id, message: "has already been billed for this month" }

  before_validation :set_year_month, on: :create

  private

  def set_year_month
    return unless billed_at.present?
    self.year_month = billed_at.strftime("%Y-%m")
  end
end
