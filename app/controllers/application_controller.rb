class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception unless Rails.env.development?

  before_action :authenticate_user!, except: [:index]
  before_action :check_subdomain

  def index
    m = 'Welcome to the xtrakcd API server! You are '
    m << 'not ' unless current_user
    m << 'logged in.'
    render text: m
  end

protected
  def latest_comic
    @n ||= Comic.order(number: :desc).first
  end

  def check_subdomain
    unless request.subdomain == 'api'
      render text: 'Use api.xtrakcd.com :)'
    end
  end

  def errs(a, status = :unprocessable_entity)
    a = [a] if a.is_a?(String)
    render json: { (a.is_a?(Hash) ? :fielderrors : :errors) => a }, status: status
  end

  def rec_errs(rec)
    errs(rec.errors.messages)
  end

  def json_not_found
    errs(['Not found'], :not_found)
  end

end
