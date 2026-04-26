require 'rails_helper'

RSpec.describe PaymentStrategies::Base do
  describe '.strategies' do
    subject(:strategies) { described_class.strategies }

    it 'returns a hash of available strategies' do
      expect(strategies).to be_a(Hash)
      expect(strategies.keys).to include('boleto', 'credit_card')
      expect(strategies['boleto']).to eq(PaymentStrategies::BoletoStrategy)
      expect(strategies['credit_card']).to eq(PaymentStrategies::CreditCardStrategy)
    end

    it 'does not load strategies again if they are already loaded' do
      described_class.strategies

      expect(described_class).not_to receive(:load_strategies)
      described_class.strategies
    end

    it 'calls load_strategies if descendants are empty' do
      allow(described_class).to receive(:descendants).and_return([])

      expect(described_class).to receive(:load_strategies).and_call_original

      described_class.strategies
    end
  end

  describe '#charge' do
    subject(:base_strategy) { described_class.new }

    it 'raises a NotImplementedError' do
      client = instance_double(Client)
      expect { base_strategy.charge(client) }.to raise_error(
        NotImplementedError,
        "PaymentStrategies::Base must implement the 'charge' method."
      )
    end
  end
end
