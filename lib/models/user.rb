class User < ActiveRecord::Base

  zodiac_reader :birthdate
  has_many :songs, through: :user_songs
  has_many :user_songs
  belongs_to :starsign

end
