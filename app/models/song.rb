class Song < ActiveRecord::Base
  belongs_to :party
  has_many :votes

  def self.search_spotify(track_song='*', track_artist='')
    gsub_track_song = track_song.gsub(' ','%20')
    gsub_track_artist = track_artist.gsub(' ','%20')

    songs_from_spotify = RestClient.get("https://api.spotify.com/v1/search?q=track:#{gsub_track_song}%20artist:#{gsub_track_artist}&limit=5&type=track")
    parsed_song = JSON.parse(songs_from_spotify)

    @songs_array = []

    parsed_song["tracks"]["items"].each do |song|
      song_hash = {}
      song_hash[:album_art] = song["album"]["images"][2]["url"]
      song_hash[:song_name] = song["name"]
      song_hash[:song_artist] = song["artists"][0]["name"]
      song_hash[:song_album] = song["album"]["name"]
      song_hash[:song_uri] = song['uri']
      song_hash[:duration_ms] = song["duration_ms"]
      @songs_array << song_hash
    end
    @songs_array
  end

  def self.persist_song(track, party)
    split_track = track.split('|;')
    uri = split_track[3]
    unless party.songs.any?{|song_in_queue| song_in_queue.spotify_uri == uri}
      song = Song.new
      song.title = split_track[0]
      song.artist = split_track[1]
      song.album = split_track[2]
      song.spotify_uri = split_track[3]
      song.album_art = split_track[4]
      song.duration_ms = split_track[5]
      song.party_id = party.id
      party.songs << song
      song.save
    end
  end

  def self.add_to_spotify(track, party)
    split_track = track.split('|;')
    uri = split_track[3]
    spotify_playlist_id = party.spotify_playlist_id
    uid = party.user.uid
    token = party.user.token
    Party.add_tracks(uid, spotify_playlist_id, token, uri)
  end
end
