class Billing::ChargeClientJob < ApplicationJob
  queue_as :default

  # Configure retry_on for 3 attempts with a 10-minute wait.
  retry_on StandardError, wait: 10.minutes, attempts: 3

  def perform(client)
    if BillingRecord.exists?(client: client, year_month: Time.now.strftime("%Y-%m"), status: "success")
      Rails.logger.info "[Billing::ChargeClientJob] Client #{client.id} has already been successfully billed this month. Skipping."
      return
    end

    strategy_class = PaymentStrategies::Base.strategies[client.payment_method_identifier]

    unless strategy_class
      handle_error(client, "Payment strategy '#{client.payment_method_identifier}' not found.")
      return
    end

    strategy = strategy_class.new
    result = strategy.charge(client)

    if result[:success]
      BillingRecord.create!(
        client: client,
        billed_at: Time.now,
        payment_method_identifier: client.payment_method_identifier,
        status: "success"
      )
      Rails.logger.info "[Billing::ChargeCustomerJob] Successfully billed client #{client.id}."
    else
      raise "Billing failed for client #{client.id}: #{result[:message]}"
    end

  rescue StandardError => e
    handle_error(client, e.message)
    raise e
  end

  private

  def handle_error(client, message)
    Rails.logger.error "[Billing::ChargeCustomerJob] Permanent failure for client #{client.id}: #{message}"
  end
end
