class SongsController < ApplicationController
  def index
  end

  def create  
  end

  def show

  end

  def update
    
     
    
     track = params{:song_to_add}

     Party.add_tracks(uid, party_id, token, track)
  end

  def delete
  end


   def songs_params
    params.require(:song).permit(:title, :artist, :album, :spotify_uri, :album_art, :duration_ms)
  end
end
  
