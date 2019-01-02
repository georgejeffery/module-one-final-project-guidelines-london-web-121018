class CreatePlaylists < ActiveRecord::Migration[5.0]
  def change
    create_table :playlists do |t|
      t.integer :user_id 
    end

    create_table :playlist_songs do |t|
      t.integer :playlist_id
      t.integer :song_id
    end

    
  end
end
