class AddStatusToIdea < ActiveRecord::Migration
  def change
    add_column :ideas, :status, :integer
  end
end
