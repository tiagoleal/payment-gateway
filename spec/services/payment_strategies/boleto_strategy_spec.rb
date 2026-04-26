require 'rails_helper'

RSpec.describe PaymentStrategies::BoletoStrategy do
  describe '#charge' do
    let(:client) { create(:client) }
    let(:strategy) { described_class.new }

    it 'logs the boleto emission' do
      expect(Rails.logger).to receive(:info).with("Boleto emitido para o cliente #{client.id} - #{client.name}")
      strategy.charge(client)
    end

    it 'returns a success message' do
      allow(Rails.logger).to receive(:info)

      result = strategy.charge(client)
      expect(result).to eq({ success: true, message: "Boleto gerado com sucesso." })
    end
  end
end
