class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :description
      t.references :user
      t.references :idea

      t.timestamps
    end
    add_index :comments, :idea_id
    add_index :comments, :user_id
  end
end
