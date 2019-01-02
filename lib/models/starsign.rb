class Starsign < ActiveRecord::Base

  belongs_to :genre
  has_many :users

end
