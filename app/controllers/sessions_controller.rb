class SessionsController < Devise::SessionsController
  prepend_before_filter :already_authenticated, only: [:create]
  
  before_filter :ensure_params_exist, only: [:create]
  respond_to :json

  def me
    return render json: {} unless current_user
    render_me
  end
  
  def create
    resource = User.find_for_database_authentication(email: params[:email])
    return invalid_login_attempt unless resource
 
    if resource.valid_password?(params[:password])
      sign_in('user', resource)
      render_me(resource)
    else
      invalid_login_attempt
    end
  end
  
  def destroy
    sign_out(resource_name)
    if all_signed_out?
      head :ok
    else
      head :internal_server_error
    end
  end
 
protected
  def ensure_params_exist
    return if [params[:email], params[:password]].all?(&:present?)
    errs('email and password required')
  end
 
  def invalid_login_attempt
    warden.custom_failure!
    errs('bad email and password combination')
  end

  def render_me(user=nil)
    @me = user || current_user
    @favourited_numbers = @me.favourited.pluck(:number)
    render 'me'
  end

private
  def all_signed_out?
    users = Devise.mappings.keys.map { |s| warden.user(scope: s, run_callbacks: false) }
    users.all?(&:blank?)
  end
end
