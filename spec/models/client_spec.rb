require 'rails_helper'

RSpec.describe Client, type: :model do
  it "is valid with all attributes" do
    client = Client.new(
      name: "Test Company",
      due_day: 15,
      payment_method_identifier: "Boleto"
    )
    expect(client).to be_valid
  end

  it "is invalid without a name" do
    client = Client.new(due_day: 15, payment_method_identifier: "Boleto")
    expect(client).not_to be_valid
    expect(client.errors[:name]).to include("can't be blank")
  end

  it "is invalid without a due_day" do
    client = Client.new(name: "Test Company", payment_method_identifier: "Boleto")
    expect(client).not_to be_valid
    expect(client.errors[:due_day]).to include("can't be blank")
  end

  it "is invalid with a non-integer due_day" do
    client = Client.new(name: "Test Company", due_day: 15.5, payment_method_identifier: "Boleto")
    expect(client).not_to be_valid
    expect(client.errors[:due_day]).to include("must be an integer")
  end

  it "is invalid with due_day less than 1" do
    client = Client.new(name: "Test Company", due_day: 0, payment_method_identifier: "Boleto")
    expect(client).not_to be_valid
    expect(client.errors[:due_day]).to include("must be greater than or equal to 1")
  end

  it "is invalid with due_day greater than 31" do
    client = Client.new(name: "Test Company", due_day: 32, payment_method_identifier: "Boleto")
    expect(client).not_to be_valid
    expect(client.errors[:due_day]).to include("must be less than or equal to 31")
  end

  it "is invalid without a payment_method_identifier" do
    client = Client.new(name: "Test Company", due_day: 15)
    expect(client).not_to be_valid
    expect(client.errors[:payment_method_identifier]).to include("can't be blank")
  end
end
