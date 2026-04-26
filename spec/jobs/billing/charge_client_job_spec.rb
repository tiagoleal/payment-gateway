require 'rails_helper'

RSpec.describe Billing::ChargeClientJob, type: :job do
  include ActiveJob::TestHelper
  include ActiveSupport::Testing::TimeHelpers

  let(:client) { create(:client, payment_method_identifier: 'credit_card') }
  let(:current_month) { Time.zone.now.strftime("%Y-%m") }
  let(:successful_charge_result) { { success: true } }
  let(:failed_charge_result) { { success: false, message: "Payment failed" } }

  let(:mock_strategy) { instance_double(PaymentStrategies::CreditCardStrategy, charge: successful_charge_result) }
  let(:mock_strategy_class) { class_double(PaymentStrategies::CreditCardStrategy, new: mock_strategy) }

  let(:mock_logger) { spy(ActiveSupport::Logger) }

  before do
    allow(PaymentStrategies::Base).to receive(:strategies).and_return({ 'credit_card' => mock_strategy_class })
    travel_to Time.zone.local(2025, 1, 15)
    allow(Rails).to receive(:logger).and_return(mock_logger)
  end

  after do
    travel_back
  end

  describe '#perform' do
    context 'when client has not been billed successfully this month' do
      it 'calls the charge method on the payment strategy' do
        expect(mock_strategy).to receive(:charge).with(client).and_return(successful_charge_result)
        described_class.perform_now(client)
      end

      it 'creates a successful BillingRecord' do
        expect {
          described_class.perform_now(client)
        }.to change(BillingRecord, :count).by(1)

        billing_record = BillingRecord.last
        expect(billing_record.client).to eq(client)
        expect(billing_record.billed_at.strftime("%Y-%m-%d")).to eq(Time.zone.now.strftime("%Y-%m-%d"))
        expect(billing_record.payment_method_identifier).to eq('credit_card')
        expect(billing_record.status).to eq('success')
      end

      it 'logs a successful billing message' do
        described_class.perform_now(client)
        expect(mock_logger).to have_received(:info).with("[Billing::ChargeCustomerJob] Successfully billed client #{client.id}.")
      end

      context 'when charging fails' do
        before do
          allow(mock_strategy).to receive(:charge).with(client).and_return(failed_charge_result)
        end

        it 'calls handle_error' do
          expect_any_instance_of(described_class).to receive(:handle_error).with(client, "Billing failed for client #{client.id}: Payment failed")
          begin
            described_class.perform_now(client)
          rescue StandardError
          end
        end

        it 'does not create a successful BillingRecord' do
          expect { described_class.perform_now(client) rescue StandardError }
            .not_to change(BillingRecord.where(status: 'success'), :count)
        end
      end
    end

    context 'when client has already been billed successfully this month' do
      before do
        create(:billing_record,
               client: client,
               year_month: current_month,
               status: 'success',
               billed_at: Time.zone.now,
               payment_method_identifier: client.payment_method_identifier
              )
      end

      it 'does not call the charge method on the payment strategy' do
        expect(mock_strategy).not_to receive(:charge)
        described_class.perform_now(client)
      end

      it 'does not create any new BillingRecord' do
        expect {
          described_class.perform_now(client)
        }.not_to change(BillingRecord, :count)
      end

      it 'logs a skipping message' do
        described_class.perform_now(client)
        expect(mock_logger).to have_received(:info).with("[Billing::ChargeClientJob] Client #{client.id} has already been successfully billed this month. Skipping.")
      end
    end

    context 'when payment strategy is not found' do
      before do
        allow(PaymentStrategies::Base).to receive(:strategies).and_return({})
      end

      it 'calls handle_error' do
        expect_any_instance_of(described_class).to receive(:handle_error).with(client, "Payment strategy 'credit_card' not found.")
        described_class.perform_now(client)
      end

      it 'does not attempt to charge' do
        expect(mock_strategy).not_to receive(:charge)
        described_class.perform_now(client)
      end

      it 'does not create a BillingRecord' do
        expect {
          described_class.perform_now(client)
        }.not_to change(BillingRecord, :count)
      end
    end
  end

  describe '#handle_error' do
    it 'logs an error message' do
      described_class.new.send(:handle_error, client, "Test error message")
      expect(mock_logger).to have_received(:error).with("[Billing::ChargeCustomerJob] Permanent failure for client #{client.id}: Test error message")
    end
  end
end
