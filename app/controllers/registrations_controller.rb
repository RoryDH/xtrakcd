class RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :already_authenticated, only: [:create]
  prepend_before_filter :authenticate_scope!, only: [:update, :destroy]
  def create
    build_resource(sign_up_params)

    resource_saved = resource.save
    if resource_saved
      if resource.active_for_authentication?
        sign_up(resource_name, resource)
        render json: { email: resource.email }
      else
        expire_data_after_sign_in!
        render json: { inactive: resource.inactive_message }
      end
    else
      clean_up_passwords resource
      rec_errs resource
    end
  end

  def update
    @user = current_user
    prev_unconfirmed_email = @user.unconfirmed_email if @user.respond_to?(:unconfirmed_email)
    user_updated = update_resource(@user, account_update_params)
    if user_updated
      sign_in 'user', @user, bypass: true
      render 'user'
    else
      clean_up_passwords @user
      rec_errs(@user)
    end
  end

  def destroy
    if current_user.destroy_with_password(params[:current_password])
      Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
      head :ok
    else
      rec_errs(current_user)
    end
  end

private
  def sign_up_params
    params.permit(:email, :password)
  end

  def account_update_params
    params.permit(:email, :current_password, :password)
  end
end
