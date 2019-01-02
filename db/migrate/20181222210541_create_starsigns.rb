class CreateStarsigns < ActiveRecord::Migration[5.0]
  def change
    create_table :starsigns do |t|
      t.string :starsign
      t.string :genre
      t.string :symbol
    end
  end
end
