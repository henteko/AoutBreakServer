# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140221071432) do

  create_table "containers", :force => true do |t|
    t.string   "name"
    t.string   "image_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "ssh_port"
    t.integer  "http_port"
    t.integer  "http_dev_port"
    t.string   "repo_url"
    t.integer  "parent_id"
  end

  create_table "ports", :force => true do |t|
    t.integer  "local_port"
    t.integer  "docker_port"
    t.integer  "container_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "docker_local_port"
  end

  add_index "ports", ["container_id"], :name => "index_ports_on_container_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "password"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
