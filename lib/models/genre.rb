class Genre < ActiveRecord::Base

belongs_to :starsign, :foreign_key => "genre_id"

end