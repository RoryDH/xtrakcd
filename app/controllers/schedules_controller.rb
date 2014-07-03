class SchedulesController < ApplicationController
  respond_to :json
  before_action :get_schedule, only: [:show, :update, :destroy]

  def index
    @schedules = current_user.schedules
  end

  def show
  end

  def create
    if current_user.has_max_schedules?
      return errs("Max schedule limit of #{User::MAX_SCHEDULES} reached.")
    end
    klass = Schedule::KIND_KLASS[params[:kind]]
    return errs('Must give valid schedule kind.') unless klass
    @schedule = klass.new(user: current_user)
    set_schedule

    if @schedule.save
      render 'show'
    else
      rec_errs(@schedule)
    end
  end

  def update
    set_schedule

    if @schedule.save
      render 'show'
    else
      rec_errs(@schedule)
    end
  end

  def destroy
    if @schedule.destroy
      head :ok
    else
      head :internal_server_error
    end
  end

private
  def get_schedule
    @schedule = current_user.schedules.find(params[:id])
  end

  def set_schedule
    @schedule.name = params[:name] if params[:name]

    if params[:active] == true && !@schedule.active?
      @schedule.activate!
    elsif params[:active] == false # not null/undefined
      @schedule.deactivate!
    end

    @schedule.class.stored_attributes[:settings].each do |s|
      value = params[s]
      next if !params.has_key?(s) || @schedule.settings[s] == value.to_s
      if value
        @schedule.settings[s] = value
      else 
        @schedule.settings[s] = nil
      end
      @schedule.settings_will_change!
    end

    if params[:destination_ids]
      @schedule.destination_ids = params[:destination_ids]
    elsif params.has_key?(:destination_ids) # silly rails makes [] in params be nil!
      @schedule.destination_ids = []
    end
  end

end
