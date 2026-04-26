class Billing::SchedulerJob < ApplicationJob
  queue_as :default

  def perform(*args)
    today = Time.zone.now.day
    Rails.logger.info "[Billing::SchedulerJob] Starting daily billing process for due day #{today}."

    clients_to_bill = Client.where(due_day: today)

    clients_to_bill.find_each do |client|
      Billing::ChargeClientJob.perform_later(client)
    end

    Rails.logger.info "[Billing::SchedulerJob] Enqueued #{clients_to_bill.count} billing jobs."
  end
end
