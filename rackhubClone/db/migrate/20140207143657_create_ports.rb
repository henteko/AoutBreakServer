class CreatePorts < ActiveRecord::Migration
  def change
    create_table :ports do |t|
      t.integer :local_port
      t.integer :docker_port
      t.references :container

      t.timestamps
    end
    add_index :ports, :container_id
  end
end
