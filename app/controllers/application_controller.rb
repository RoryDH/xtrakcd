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
    return render json: { errors: rec.errors.messages }
  end

end
