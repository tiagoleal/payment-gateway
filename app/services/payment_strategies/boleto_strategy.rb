class PaymentStrategies::BoletoStrategy < PaymentStrategies::Base
  def charge(client)
    Rails.logger.info "Boleto emitido para o cliente #{client.id} - #{client.name}"
    { success: true, message: "Boleto gerado com sucesso." }
  end
end
