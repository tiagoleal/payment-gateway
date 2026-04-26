class ApplicationController < ActionController::Base
  include Authentication
  before_action :set_locale
  allow_browser versions: :modern

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
