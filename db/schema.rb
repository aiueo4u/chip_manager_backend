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

ActiveRecord::Schema.define(version: 0) do

  create_table "client_versions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC" do |t|
    t.string "version", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "game_actions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC" do |t|
    t.integer "game_hand_id", null: false, unsigned: true
    t.integer "order_id", null: false, unsigned: true
    t.integer "state", null: false, unsigned: true
    t.integer "player_id", null: false, unsigned: true
    t.integer "action_type", null: false, unsigned: true
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_hand_id"], name: "i1"
  end

  create_table "game_hand_players", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC" do |t|
    t.integer "game_hand_id", unsigned: true
    t.integer "player_id", unsigned: true
    t.integer "initial_stack", default: 0, null: false, unsigned: true
    t.string "card1_id", limit: 2
    t.string "card2_id", limit: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_hand_id"], name: "i1"
  end

  create_table "game_hands", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC" do |t|
    t.integer "table_id", null: false, unsigned: true
    t.integer "button_seat_no", null: false, unsigned: true
    t.string "board_card1_id", limit: 2
    t.string "board_card2_id", limit: 2
    t.string "board_card3_id", limit: 2
    t.string "board_card4_id", limit: 2
    t.string "board_card5_id", limit: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["table_id"], name: "i1"
  end

  create_table "other_service_accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC" do |t|
    t.integer "player_id", null: false, unsigned: true
    t.integer "provider", null: false, unsigned: true
    t.string "uid", limit: 64, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id", "provider"], name: "i1", unique: true
    t.index ["uid"], name: "i2", unique: true
  end

  create_table "players", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC" do |t|
    t.string "nickname", null: false
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "table_messages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC" do |t|
    t.integer "table_id", null: false, unsigned: true
    t.integer "player_id", null: false, unsigned: true
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.index ["table_id"], name: "i1"
  end

  create_table "table_players", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC" do |t|
    t.integer "table_id", null: false, unsigned: true
    t.integer "player_id", null: false, unsigned: true
    t.integer "stack", default: 0, null: false, unsigned: true
    t.integer "seat_no", null: false, unsigned: true
    t.boolean "auto_play", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "i1"
    t.index ["table_id", "player_id"], name: "i2", unique: true
    t.index ["table_id", "seat_no"], name: "i3", unique: true
  end

  create_table "tables", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC" do |t|
    t.string "name", null: false
    t.integer "sb_size", null: false, unsigned: true
    t.integer "bb_size", null: false, unsigned: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
