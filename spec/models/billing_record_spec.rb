require 'rails_helper'

RSpec.describe BillingRecord, type: :model do
  let(:client) { Client.create!(name: "Test Client", due_day: 1, payment_method_identifier: "Test") }

  it "is valid with all attributes" do
    record = BillingRecord.new(
      client: client,
      billed_at: Time.now,
      payment_method_identifier: "Boleto",
      status: "success"
    )
    expect(record).to be_valid
  end

  it "sets the year_month before validation on create" do
    billed_time = Time.zone.local(2025, 10, 5)
    record = BillingRecord.new(
      client: client,
      billed_at: billed_time,
      payment_method_identifier: "Boleto",
      status: "success"
    )
    expect(record).to be_valid # triggers before_validation
    expect(record.year_month).to eq("2025-10")
  end

  it "is invalid without a client" do
    record = BillingRecord.new(billed_at: Time.now, payment_method_identifier: "Boleto", status: "success")
    expect(record).not_to be_valid
  end

  it "is invalid without billed_at" do
    record = BillingRecord.new(client: client, payment_method_identifier: "Boleto", status: "success")
    expect(record).not_to be_valid
    expect(record.errors[:billed_at]).to include("can't be blank")
  end

  context "uniqueness validation" do
    before do
      BillingRecord.create!(
        client: client,
        billed_at: Time.now,
        payment_method_identifier: "Boleto",
        status: "success"
      )
    end

    it "is invalid for the same client in the same month" do
      duplicate_record = BillingRecord.new(
        client: client,
        billed_at: Time.now,
        payment_method_identifier: "Boleto",
        status: "success"
      )
      expect(duplicate_record).not_to be_valid
      expect(duplicate_record.errors[:year_month]).to include("has already been billed for this month")
    end
  end
end
