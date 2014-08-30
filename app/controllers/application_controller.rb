class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception unless Rails.env.development?

  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound do |exception|
    errs('record_not_found')
  end

  rescue_from JSON::ParserError do |exception|
    errs('invalid_json')
  end

protected
  def latest_comic
    @n ||= Comic.latest
  end

  def errs(message, status = :unprocessable_entity)
    message = [message] if message.is_a?(String)
    render json: { (message.is_a?(Hash) ? :fielderrors : :errors) => message }, status: status
  end

  def rec_errs(rec)
    errs(rec.errors.messages)
  end

  def json_not_found
    errs(['Not found'], :not_found)
  end

  def already_authenticated # Custom version of devise :require_no_authentication
    assert_is_devise_resource!
    no_input = devise_mapping.no_input_strategies

    authenticated = if no_input.present?
      args = no_input.dup.push scope: resource_name
      warden.authenticate?(*args)
    else
      warden.authenticated?(resource_name)
    end

    if authenticated && resource = warden.user(resource_name)
      errs('already_authenticated', :method_not_allowed)
    end
  end

end
