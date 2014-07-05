class MiscController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    m = 'Welcome to the xtrakcd API server! You are '
    m << (current_user ? "logged in as #{current_user.email}" : "not logged in.")
    render text: m
  end
end
