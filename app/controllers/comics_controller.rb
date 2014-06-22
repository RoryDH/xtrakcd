class ComicsController < ApplicationController
  before_action :get_comic, only: [:show]

  respond_to :json

  def index
    format_search_query
    db = Comic
    if @q
      db = db.search(@q)
    end
    @comics = db.limit(20)
  end

  def show
  end

private
  def get_comic
    @comic = Comic.find_by_number!(params[:id])
  end

  def format_search_query
    return if (!params[:q] || params[:q] == "")
    @q = params[:q].downcase
  end
end
