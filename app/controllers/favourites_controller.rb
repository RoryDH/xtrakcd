class FavouritesController < ApplicationController
  def index
    @comics = current_user.favourited
    render 'comics/index'
  end

  def create
    comic = Comic.find_by_number!(params[:id])
    fav = current_user.favourite_comic(comic)
    if fav.save
      head :ok
    else
      rec_errs(fav)
    end
  end

  def destroy
    comic = Comic.find_by_number!(params[:id])
    fav = current_user.favourites.find_by_favable_id!(comic.id)
    if fav.destroy!
      head :ok
    else
      head :not_found
    end
  end
end
