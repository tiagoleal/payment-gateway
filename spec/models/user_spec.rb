require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is invalid without a name" do
      subject.name = nil
      expect(subject).not_to be_valid
      subject.valid?
      expect(subject.errors[:name]).to include("can't be blank")
    end

    it "is invalid without an email_address" do
      subject.email_address = nil
      expect(subject).not_to be_valid
      subject.valid?
      expect(subject.errors[:email_address]).to include("can't be blank")
    end

    it "is invalid without a password on create" do
      subject.password = nil
      expect(subject).not_to be_valid
      subject.valid?
      expect(subject.errors[:password]).to include("can't be blank")
    end

    it "validates uniqueness of email_address (case insensitive)" do
      create(:user, email_address: "duplicate@example.com")
      subject.email_address = "DUPLICATE@EXAMPLE.COM"
      expect(subject).not_to be_valid
      subject.valid?
      expect(subject.errors[:email_address]).to include("has already been taken")
    end
  end

  describe "email normalization" do
    it "downcases and strips email_address" do
      user = create(:user, email_address: "  TEST@Example.COM  ")
      expect(user.email_address).to eq("test@example.com")
    end
  end

  describe "password security" do
    it "authenticates with correct password" do
      user = create(:user, password: "password")
      expect(user.authenticate("password")).to eq(user)
    end

    it "does not authenticate with incorrect password" do
      user = create(:user, password: "password")
      expect(user.authenticate("wrongpassword")).to be_falsey
    end
  end
end
