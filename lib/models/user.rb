class User < ActiveRecord::Base
  
  zodiac_reader :birthdate
  has_many :songs, through: :user_songs
  has_many :user_songs
  has_one :starsign, :foreign_key => "id" 

end