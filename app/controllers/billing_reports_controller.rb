class BillingReportsController < ApplicationController
  def index
    report = BillingReportService.call
    @executed_billings = report[:executed_billings].page(params[:executed_billings_page]).per(10)
    @pending_clients_to_bill = report[:pending_clients_to_bill].page(params[:pending_billings_page]).per(10)
  end
end
