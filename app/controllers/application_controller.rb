class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  # protect_from_forgery with: :exception

  before_action :authenticate_user!

  def latest_comic
    @n ||= Comic.order(number: :desc).first
  end

protected
  def errs(a, status = :unprocessable_entity)
    a = [a] if a.is_a?(String)
    render json: { (a.is_a?(Hash) ? :fielderrors : :errors) => a }, status: status
  end

  def rec_errs(rec)
    errs(rec.errors.messages)
  end

  def json_not_found
    errs(["Not found"], :not_found)
  end

end
