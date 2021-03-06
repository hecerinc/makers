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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_03_02_233612) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "capabilities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "equipment", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "lab_space_id"
    t.index ["lab_space_id"], name: "index_equipment_on_lab_space_id"
  end

  create_table "equipment_capabilities", force: :cascade do |t|
    t.bigint "capability_id", null: false
    t.bigint "equipment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["capability_id"], name: "index_equipment_capabilities_on_capability_id"
    t.index ["equipment_id"], name: "index_equipment_capabilities_on_equipment_id"
  end

  create_table "equipment_materials", force: :cascade do |t|
    t.bigint "material_id", null: false
    t.bigint "equipment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["equipment_id"], name: "index_equipment_materials_on_equipment_id"
    t.index ["material_id"], name: "index_equipment_materials_on_material_id"
  end

  create_table "lab_spaces", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "hours"
    t.string "location"
    t.string "contact_email"
    t.string "contact_phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "lab_id"
    t.string "image"
    t.index ["lab_id"], name: "index_lab_spaces_on_lab_id"
  end

  create_table "labs", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
  end

  create_table "materials", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "equipment", "lab_spaces"
  add_foreign_key "equipment_capabilities", "capabilities"
  add_foreign_key "equipment_capabilities", "equipment"
  add_foreign_key "equipment_materials", "equipment"
  add_foreign_key "equipment_materials", "materials"
  add_foreign_key "lab_spaces", "labs"
end
