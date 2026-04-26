class BillingReportService
  attr_reader :date

  def self.call(date: Time.zone.now)
    new(date: date).call
  end

  def initialize(date:)
    @date = date
  end

  def call
    {
      executed_billings: executed_billings,
      pending_clients_to_bill: pending_clients_to_bill
    }
  end

  private

  def executed_billings
    @executed_billings ||= base_executed_billings_query.includes(:client).order(billed_at: :desc)
  end

  def pending_clients_to_bill
    billed_client_ids = base_executed_billings_query.pluck(:client_id)

    clients_due_soon
      .where.not(id: billed_client_ids)
      .order(:due_day)
  end

  def clients_due_soon
    Client.where(due_day: upcoming_due_days)
  end

  def base_executed_billings_query
    BillingRecord.where(status: "success", year_month: current_month_year)
  end

  def upcoming_due_days
    (date.day..days_in_month)
  end

  def days_in_month
    Time.days_in_month(date.month, date.year)
  end

  def current_month_year
    date.strftime("%Y-%m")
  end
end
