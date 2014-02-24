class AddAccessTokenToContainers < ActiveRecord::Migration
  def change
    add_column :containers, :repo_url, :string
  end
end
