class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.boolean :like
      t.references :user
      t.references :idea

      t.timestamps
    end
    add_index :votes, :idea_id
    add_index :votes, :user_id
  end
end