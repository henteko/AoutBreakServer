class AddDockerLocalPortToPorts < ActiveRecord::Migration
  def change
    add_column :ports, :docker_local_port, :integer
  end
end
