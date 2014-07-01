class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  # protect_from_forgery with: :exception

  before_action :authenticate_user!

  def latest_comic
    @n ||= Comic.order(number: :desc).first
  end

protected
  def rec_errs(rec)
    render json: { fielderrors: rec.errors.messages }, status: :unprocessable_entity
  end

  def json_not_found
    render json: { errors: ["Not found"] }, status: :not_found
  end

end
