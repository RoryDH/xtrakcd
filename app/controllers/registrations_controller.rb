class RegistrationsController < Devise::RegistrationsController
  def me
    render json: {} unless current_user
    @favourited_numbers = current_user.favourited.pluck(:number)
  end
end
