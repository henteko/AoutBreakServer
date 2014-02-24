class AddPortToContainer < ActiveRecord::Migration
  def change
    add_column :containers, :ssh_port, :integer
    add_column :containers, :http_port, :integer
  end
end
