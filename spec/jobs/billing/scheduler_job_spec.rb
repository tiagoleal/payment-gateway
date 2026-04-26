require 'rails_helper'

RSpec.describe Billing::SchedulerJob, type: :job do
  include ActiveJob::TestHelper
  include ActiveSupport::Testing::TimeHelpers

  let(:today) { Time.zone.local(2025, 1, 15) }
  let!(:client_other_day) { create(:client, due_day: today.day + 1) }

  before do
    travel_to today
  end

  after do
    travel_back
  end

  describe '#perform' do
    let!(:client_today) { create(:client, due_day: today.day) }

    it 'selects clients with the current due_day' do
      expect(Client).to receive(:where).with(due_day: today.day).and_call_original
      described_class.perform_now
    end

    it 'enqueues Billing::ChargeClientJob for each client with the current due_day' do
      expect {
        described_class.perform_now
      }.to have_enqueued_job(Billing::ChargeClientJob).on_queue('default').with(client_today)
    end

    it 'does not enqueue Billing::ChargeClientJob for clients with a different due_day' do
      expect {
        described_class.perform_now
      }.not_to have_enqueued_job(Billing::ChargeClientJob).on_queue('default').with(client_other_day)
    end

    it 'logs the start and completion of the job' do
      logger_double = instance_double(ActiveSupport::Logger)
      allow(Rails).to receive(:logger).and_return(logger_double)

      expect(logger_double).to receive(:info).with("[Billing::SchedulerJob] Starting daily billing process for due day #{today.day}.").ordered
      expect(logger_double).to receive(:info).with("[Billing::SchedulerJob] Enqueued 1 billing jobs.").ordered
      described_class.perform_now
    end

    it 'enqueues the correct number of jobs' do
      expect {
        described_class.perform_now
      }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
    end
  end
end
