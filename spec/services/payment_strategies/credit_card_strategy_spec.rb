require 'rails_helper'

RSpec.describe PaymentStrategies::CreditCardStrategy do
  describe '#charge' do
    let(:client) { create(:client) }
    let(:strategy) { described_class.new }

    it 'logs the credit card charge' do
      expect(Rails.logger).to receive(:info).with("Cartão de crédito debitado para o cliente #{client.id} - #{client.name}")
      strategy.charge(client)
    end

    it 'returns a success message' do
      allow(Rails.logger).to receive(:info)

      result = strategy.charge(client)
      expect(result).to eq({ success: true, message: "Pagamento com cartão de crédito aprovado." })
    end
  end
end
