class ComicsController < ApplicationController
  before_filter :find_model

  

private
  def find_model
    @comic = Comics.find(params[:number]) if params[:number]
  end
endcl
