class AddHttpDevPortToContainer < ActiveRecord::Migration
  def change
    add_column :containers, :http_dev_port, :integer
  end
end
