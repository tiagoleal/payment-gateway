class ClientsController < ApplicationController
  before_action :set_client, only: %i[ show edit update destroy ]
  before_action :set_payment_strategies, only: %i[ new edit create update ]

  def index
    @clients = Client.page(params[:page])
  end

  def show
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)

    if @client.save
      redirect_to @client, notice: "Client was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @client.update(client_params)
      redirect_to @client, notice: "Client was successfully updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @client.destroy
    redirect_to clients_url, notice: "Client was successfully destroyed."
  end

  private

  def set_client
    @client = Client.find(params[:id])
  end

  def set_payment_strategies
    @payment_strategies = PaymentStrategies::Base.strategies.map do |_name, strategy_class|
      identifier = strategy_class.name.demodulize.underscore.chomp("_strategy")
      display_name = I18n.t("payment_strategies.#{identifier}", default: identifier.humanize)
      [ display_name, identifier ]
    end
  end

  def client_params
    params.require(:client).permit(:name, :due_day, :payment_method_identifier)
  end
end
