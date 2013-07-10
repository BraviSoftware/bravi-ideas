class ChangeDescriptionStringColumnToText < ActiveRecord::Migration
  def up
    change_column :ideas, :description, :text
  end

  def down
    change_column :ideas, :description, :string
  end
end
