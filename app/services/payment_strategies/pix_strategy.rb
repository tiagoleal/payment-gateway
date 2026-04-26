class PaymentStrategies::PixStrategy < PaymentStrategies::Base
  def charge(client)
    Rails.logger.info "Pix realizado para o cliente #{client.id} - #{client.name}"
    { success: true, message: "Pix gerado com sucesso." }
  end
end
