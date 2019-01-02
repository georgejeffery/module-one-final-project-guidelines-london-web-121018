class Starsign < ActiveRecord::Base

  belongs_to :genre
  has_many :users #:foreign_key => "starsign_id"
  
end