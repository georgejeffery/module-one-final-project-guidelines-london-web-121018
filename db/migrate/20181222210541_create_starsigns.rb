class CreateStarsigns < ActiveRecord::Migration[5.0]
  def change
    create_table :starsigns do |t|
      t.string :name
      t.integer :genre_id
      t.string :symbol
      t.string :content
    end
    
    create_table :genres do |t|
      t.string :name
    end
  
  end

end
