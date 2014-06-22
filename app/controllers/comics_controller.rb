class ComicsController < ApplicationController
  before_action :get_comic, only: [:show]

  respond_to :json

  def index
    format_search_query
    db = Comic
    if @q
      db = db.search(@q)
    end
    per = params[:per]
    per = 20 unless per.present?

    @comics = db.page(params[:page]).per(per)
  end

  def show
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
end
