class ComicsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :latest, :random]
  before_action :get_comic, only: [:show]
  respond_to :json
  rescue_from ActiveRecord::RecordNotFound, with: :json_not_found

  def index
    format_search_query
    query = if @q
      Comic.search(@q)
    else
      Comic.order_with_defaults(params[:order_by], params[:order_dir])
    end

    @comics = query.page(params[:page]).per(params[:per])
  end

  def show
  end

  def latest
    @comic = latest_comic
    render 'show'
  end

  def random
    lower, upper = number_input(params[:from], params[:to])
    lower ||= 1
    upper ||= latest_comic.number
    @comic = Comic.random(lower, upper)
    render 'show'
  end

private
  def get_comic
    @comic = Comic.find_by_number!(params[:id])
  end

  def format_search_query
    q = params[:q]
    return unless q.present?
    @q = q.downcase
  end

  def number_input(*args)
    args.map do |a|
      a = a.to_i
      (a < 1 || a.blank? || a > latest_comic.number) ? nil : a
    end
  end
end
