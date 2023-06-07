# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_06_07_060358) do
  create_table "assigned_experiments", force: :cascade do |t|
    t.integer "device_id", null: false
    t.string "experiment_name", null: false
    t.string "experiment_option", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id", "experiment_name"], name: "index_assigned_experiments_on_device_id_and_experiment_name", unique: true
    t.index ["device_id"], name: "index_assigned_experiments_on_device_id"
  end

  create_table "devices", force: :cascade do |t|
    t.string "device_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "assigned_experiments", "devices"
end
