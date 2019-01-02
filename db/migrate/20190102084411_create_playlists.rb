class CreatePlaylists < ActiveRecord::Migration[5.0]
  def change
    create_table :playlists do |t|
      t.integer :user_id 
    end

    create_table :user_songs do |t|
      t.integer :user_id
      t.integer :song_id
    end

    
  end
end
