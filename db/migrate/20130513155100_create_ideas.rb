class CreateIdeas < ActiveRecord::Migration
  def change
    create_table :ideas do |t|
      t.string :title
      t.string :description
      t.integer :positive
      t.integer :negative
      t.date :created_date

      t.timestamps
    end
  end
end
