class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.datetime :birthdate
      t.integer :starsign_id
      t.integer :playlist_id
    end
  end
end
