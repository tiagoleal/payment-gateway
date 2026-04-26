class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  validates :name, presence: true
  validates :email_address, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, on: :create

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
