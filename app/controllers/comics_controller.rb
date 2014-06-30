class ComicsController < ApplicationController
  before_action :get_comic, only: [:show]

  respond_to :json

  def index
    format_search_query
    db = Comic.order(number: :desc)
    if @q
      db = db.search(@q)
    end
    per = params[:per]
    per = 20 unless per.present?

    @comics = db.page(params[:page]).per(per)
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
