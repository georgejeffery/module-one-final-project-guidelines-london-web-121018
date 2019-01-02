class Playlist < ActiveRecord::Base
  belongs_to :user, :foreign_key => 'playlist_id'
  has_many :playlist_songs
end