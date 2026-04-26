class PaymentStrategies::CreditCardStrategy < PaymentStrategies::Base
  def charge(client)
    Rails.logger.info "Cartão de crédito debitado para o cliente #{client.id} - #{client.name}"
    { success: true, message: "Pagamento com cartão de crédito aprovado." }
  end
end
