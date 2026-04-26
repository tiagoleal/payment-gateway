class PaymentStrategies::Base
  def self.load_strategies
    Dir[Rails.root.join("app/services/payment_strategies/*_strategy.rb")].each do |file|
      require_dependency file
    end
  end

  def self.strategies
    load_strategies if descendants.empty?
    descendants.map do |strategy|
      key = strategy.name.demodulize.chomp("Strategy").underscore
      [ key, strategy ]
    end.to_h
  end

  def charge(client)
    raise NotImplementedError, "#{self.class.name} must implement the 'charge' method."
  end
end
