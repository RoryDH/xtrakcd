class DestinationsController < ApplicationController
  respond_to :json
  before_action :get_destination, only: [:show, :update, :destroy, :test]

  def index
    @dests = current_user.destinations
  end

  def show
  end

  def create
    if current_user.has_max_destinations?
      return errs("Max destination limit of #{User::MAX_SCHEDULES} reached.")
    end
    klass = Destination::KIND_KLASS[params[:kind]]
    return errs('Must give valid destination kind.') unless klass
    @dest = klass.new(user_id: current_user.id)
    set_destination

    if @dest.save
      render 'show'
    else
      rec_errs(@dest)
    end
  end

  def update
    set_destination

    if @dest.save
      render 'show'
    else
      rec_errs(@dest)
    end
  end

  def destroy
    if @dest.destroy
      head :ok
    else
      head :internal_server_error
    end
  end

  def test
    @dest.test_success!

    if @dest.save
      render 'show'
    else
      rec_errs(@dest)
    end
  end

private
  def get_destination
    @dest = current_user.destinations.find(params[:id])
  end

  def set_destination
    @dest.name = params[:name] if params[:name].present?

    s = @dest.settings
    @dest.class.stored_attributes[:settings].each do |key|
      value = params[key]
      next if !params.has_key?(key) || s[key] == value.to_s
      if value
        s[key] = value
      else 
        s[key] = nil
      end
      @dest.settings_will_change!
    end

  end

end
