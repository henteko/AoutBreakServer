class AddToParentToContainers < ActiveRecord::Migration
  def change
    add_column :containers, :parent_id, :integer
  end
end
