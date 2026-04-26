class Client < ApplicationRecord
  validates :name, presence: true
  validates :due_day, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 31 }
  validates :payment_method_identifier, presence: true
end
