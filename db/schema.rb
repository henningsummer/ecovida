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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20201204141717) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "name"
    t.string   "login",           null: false
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "certificate_addresses", force: :cascade do |t|
    t.integer  "certificate_id"
    t.string   "address"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "certificate_addresses", ["certificate_id"], name: "index_certificate_addresses_on_certificate_id", using: :btree

  create_table "certificate_families", force: :cascade do |t|
    t.integer  "certificate_id"
    t.string   "name"
    t.integer  "farmer_family_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "certificate_families", ["certificate_id"], name: "index_certificate_families_on_certificate_id", using: :btree
  add_index "certificate_families", ["farmer_family_id"], name: "index_certificate_families_on_farmer_family_id", using: :btree

  create_table "certificate_groups", force: :cascade do |t|
    t.string   "meeting_number"
    t.string   "meeting_page"
    t.date     "meeting_date"
    t.integer  "group_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "core_name"
    t.string   "group_name"
    t.string   "coordinate_name"
    t.integer  "city_id"
  end

  add_index "certificate_groups", ["city_id"], name: "index_certificate_groups_on_city_id", using: :btree
  add_index "certificate_groups", ["group_id"], name: "index_certificate_groups_on_group_id", using: :btree

  create_table "certificate_names", force: :cascade do |t|
    t.string   "name"
    t.integer  "farmer_id"
    t.integer  "production_unity_id"
    t.integer  "certificate_id"
    t.string   "name_type"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "number"
    t.integer  "number_type"
    t.string   "farmer_code"
  end

  add_index "certificate_names", ["certificate_id"], name: "index_certificate_names_on_certificate_id", using: :btree
  add_index "certificate_names", ["farmer_id"], name: "index_certificate_names_on_farmer_id", using: :btree
  add_index "certificate_names", ["production_unity_id"], name: "index_certificate_names_on_production_unity_id", using: :btree

  create_table "certificate_products", force: :cascade do |t|
    t.integer  "certificate_id"
    t.boolean  "contain_organic"
    t.string   "name"
    t.integer  "product_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "certificate_products", ["certificate_id"], name: "index_certificate_products_on_certificate_id", using: :btree
  add_index "certificate_products", ["product_id"], name: "index_certificate_products_on_product_id", using: :btree

  create_table "certificates", force: :cascade do |t|
    t.string   "certificate_type"
    t.integer  "certificate_group_id"
    t.integer  "pruduction_quantity"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "city_name"
    t.datetime "dac_date"
    t.string   "number"
    t.string   "number_type"
  end

  add_index "certificates", ["certificate_group_id"], name: "index_certificates_on_certificate_group_id", using: :btree

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.integer  "state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "cities", ["state_id"], name: "index_cities_on_state_id", using: :btree

  create_table "core_coordinators", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.integer  "core_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "current"
  end

  add_index "core_coordinators", ["core_id"], name: "index_core_coordinators_on_core_id", using: :btree

  create_table "core_payments", force: :cascade do |t|
    t.integer "core_id"
    t.decimal "amount",        precision: 8, scale: 2
    t.date    "payment_date"
    t.string  "description"
    t.integer "in_force_year"
  end

  add_index "core_payments", ["core_id"], name: "index_core_payments_on_core_id", using: :btree

  create_table "cores", force: :cascade do |t|
    t.string   "name"
    t.string   "login"
    t.string   "password_digest"
    t.boolean  "total_power"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "state_id"
    t.string   "email"
    t.string   "phone"
    t.string   "coordinator_name"
    t.string   "coordinator_email"
    t.string   "coordinator_phone"
    t.integer  "number_from_state"
    t.boolean  "sig_org_access"
    t.boolean  "inactive_certificate", default: false
    t.integer  "next_farmer_count",    default: 0
  end

  add_index "cores", ["state_id"], name: "index_cores_on_state_id", using: :btree

  create_table "dac_documents", force: :cascade do |t|
    t.integer  "group_id"
    t.string   "file"
    t.date     "dac_date"
    t.string   "status"
    t.text     "observations"
    t.text     "rejection_reason"
    t.date     "approved_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "dac_documents", ["group_id"], name: "index_dac_documents_on_group_id", using: :btree

  create_table "dacs", force: :cascade do |t|
    t.date     "dac_date"
    t.boolean  "sampling"
    t.integer  "farmer_id"
    t.string   "added_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "dacs", ["farmer_id"], name: "index_dacs_on_farmer_id", using: :btree

  create_table "daps", force: :cascade do |t|
    t.string   "dap_number"
    t.date     "validity"
    t.date     "emission_date"
    t.string   "added_by"
    t.integer  "farmer_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "daps", ["farmer_id"], name: "index_daps_on_farmer_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "document_sended_histories", force: :cascade do |t|
    t.integer  "document_sended_id"
    t.string   "file"
    t.string   "url"
    t.date     "approved_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "document_sended_histories", ["document_sended_id"], name: "index_document_sended_histories_on_document_sended_id", using: :btree

  create_table "document_sended_statuses", force: :cascade do |t|
    t.integer  "document_sended_id"
    t.string   "status"
    t.string   "reason"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "document_sended_statuses", ["document_sended_id"], name: "index_document_sended_statuses_on_document_sended_id", using: :btree

  create_table "document_sendeds", force: :cascade do |t|
    t.integer  "document_id"
    t.integer  "subject_id"
    t.string   "subject_type"
    t.string   "status"
    t.string   "approved_at"
    t.string   "url"
    t.text     "observations"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "file"
    t.text     "rejection_reason"
  end

  add_index "document_sendeds", ["document_id"], name: "index_document_sendeds_on_document_id", using: :btree
  add_index "document_sendeds", ["subject_type", "subject_id"], name: "index_document_sendeds_on_subject_type_and_subject_id", using: :btree

  create_table "document_visualizations", force: :cascade do |t|
    t.string   "access_key"
    t.datetime "expire_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "documents", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "subject"
    t.string   "upload_type"
    t.string   "status"
    t.string   "required_for_certificate"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "farmer_families", force: :cascade do |t|
    t.string   "name"
    t.string   "cpf"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "farmer_id"
    t.string   "gender"
    t.date     "birthday"
  end

  add_index "farmer_families", ["farmer_id"], name: "index_farmer_families_on_farmer_id", using: :btree

  create_table "farmer_group_changes", force: :cascade do |t|
    t.integer  "farmer_id"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "farmer_group_changes", ["farmer_id"], name: "index_farmer_group_changes_on_farmer_id", using: :btree
  add_index "farmer_group_changes", ["group_id"], name: "index_farmer_group_changes_on_group_id", using: :btree

  create_table "farmer_suspension_reasons", force: :cascade do |t|
    t.integer  "farmer_suspension_id"
    t.integer  "suspension_type_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "farmer_suspension_reasons", ["farmer_suspension_id"], name: "index_farmer_suspension_reasons_on_farmer_suspension_id", using: :btree
  add_index "farmer_suspension_reasons", ["suspension_type_id"], name: "index_farmer_suspension_reasons_on_suspension_type_id", using: :btree

  create_table "farmer_suspensions", force: :cascade do |t|
    t.string   "description"
    t.date     "suspension_date"
    t.string   "suspension_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "farmer_id"
  end

  add_index "farmer_suspensions", ["farmer_id"], name: "index_farmer_suspensions_on_farmer_id", using: :btree

  create_table "farmers", force: :cascade do |t|
    t.string   "name"
    t.integer  "number_type"
    t.string   "number"
    t.string   "address"
    t.string   "neighborhood"
    t.integer  "city_id"
    t.string   "phone_number"
    t.string   "cell_phone"
    t.string   "email"
    t.integer  "group_id"
    t.boolean  "suspended"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "farmer_code"
    t.boolean  "em_ata"
    t.boolean  "termo_compromisso"
    t.text     "lembrete"
    t.string   "rg"
    t.string   "spouse"
    t.string   "spouse_cpf"
    t.boolean  "excluded"
    t.boolean  "excluded_with_group",  default: false
    t.boolean  "contract_of_adhesion", default: false
    t.string   "gender"
    t.date     "birthday"
    t.date     "spouse_birthday"
    t.string   "spouse_gender"
  end

  add_index "farmers", ["city_id"], name: "index_farmers_on_city_id", using: :btree
  add_index "farmers", ["group_id"], name: "index_farmers_on_group_id", using: :btree

  create_table "group_types", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name",                            null: false
    t.integer  "core_id"
    t.string   "login",                           null: false
    t.string   "password_digest"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "titular_id"
    t.integer  "suplente_id"
    t.integer  "group_type_id"
    t.string   "email"
    t.string   "phone"
    t.boolean  "excluded",        default: false
  end

  add_index "groups", ["core_id"], name: "index_groups_on_core_id", using: :btree
  add_index "groups", ["group_type_id"], name: "index_groups_on_group_type_id", using: :btree

  create_table "product_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "scope_id"
  end

  add_index "product_categories", ["scope_id"], name: "index_product_categories_on_scope_id", using: :btree

  create_table "product_scopes", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "scope_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "product_scopes", ["product_id"], name: "index_product_scopes_on_product_id", using: :btree
  add_index "product_scopes", ["scope_id"], name: "index_product_scopes_on_scope_id", using: :btree

  create_table "production_unities", force: :cascade do |t|
    t.string   "fantasy_name"
    t.string   "name"
    t.string   "number"
    t.string   "register_type"
    t.string   "register_number"
    t.string   "address"
    t.string   "neighborhood"
    t.integer  "city_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "group_id"
    t.integer  "scope_type"
    t.string   "total_area"
    t.string   "total_organic_area"
    t.string   "total_native_area"
    t.string   "phone"
    t.string   "email"
    t.string   "production_type"
    t.integer  "number_type"
    t.string   "cep"
    t.integer  "lat_hour"
    t.integer  "lat_minute"
    t.decimal  "lat_second"
    t.string   "lat_type"
    t.integer  "lon_hour"
    t.integer  "lon_minute"
    t.decimal  "lon_second"
    t.string   "lon_type"
    t.boolean  "excluded"
    t.boolean  "excluded_with_group", default: false
  end

  add_index "production_unities", ["city_id"], name: "index_production_unities_on_city_id", using: :btree
  add_index "production_unities", ["group_id"], name: "index_production_unities_on_group_id", using: :btree

  create_table "production_unity_farmers", force: :cascade do |t|
    t.integer  "farmer_id"
    t.integer  "production_unity_id"
    t.boolean  "is_responsible"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "production_unity_farmers", ["farmer_id"], name: "index_production_unity_farmers_on_farmer_id", using: :btree
  add_index "production_unity_farmers", ["production_unity_id"], name: "index_production_unity_farmers_on_production_unity_id", using: :btree

  create_table "production_unity_scopes", force: :cascade do |t|
    t.integer  "scope_id"
    t.integer  "production_unity_id"
    t.float    "total_area"
    t.float    "organic_production_area"
    t.float    "bushland_area"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "production_unity_scopes", ["production_unity_id"], name: "index_production_unity_scopes_on_production_unity_id", using: :btree
  add_index "production_unity_scopes", ["scope_id"], name: "index_production_unity_scopes_on_scope_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.integer  "product_category_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "products", ["product_category_id"], name: "index_products_on_product_category_id", using: :btree

  create_table "scope_products", force: :cascade do |t|
    t.float    "amount"
    t.string   "unity"
    t.float    "package_size"
    t.string   "package_size_unity"
    t.float    "amount_per_year"
    t.string   "amount_per_year_unity"
    t.integer  "product_id"
    t.integer  "production_unity_scope_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.float    "area"
    t.boolean  "is_processor"
  end

  add_index "scope_products", ["product_id"], name: "index_scope_products_on_product_id", using: :btree
  add_index "scope_products", ["production_unity_scope_id"], name: "index_scope_products_on_production_unity_scope_id", using: :btree

  create_table "scopes", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "acronym"
    t.integer  "scope_type"
  end

  create_table "set_suplentes", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "farmer_id"
    t.integer  "set_type"
    t.text     "description"
    t.string   "added_by"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "set_suplentes", ["farmer_id"], name: "index_set_suplentes_on_farmer_id", using: :btree
  add_index "set_suplentes", ["group_id"], name: "index_set_suplentes_on_group_id", using: :btree

  create_table "sigorg_changes", force: :cascade do |t|
    t.integer  "sigorg_id"
    t.string   "changed_column"
    t.string   "value"
    t.date     "change_date"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "sigorg_changes", ["sigorg_id"], name: "index_sigorg_changes_on_sigorg_id", using: :btree

  create_table "sigorgs", force: :cascade do |t|
    t.integer  "farmer_id"
    t.integer  "production_unity_id"
    t.string   "sig_org_type"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "sigorgs", ["farmer_id"], name: "index_sigorgs_on_farmer_id", using: :btree
  add_index "sigorgs", ["production_unity_id"], name: "index_sigorgs_on_production_unity_id", using: :btree

  create_table "states", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "uf"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "suspension_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "system_logs", force: :cascade do |t|
    t.string   "description"
    t.string   "author"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "system_settings", force: :cascade do |t|
    t.decimal  "basic_annuity_rate",             precision: 8, scale: 2
    t.decimal  "single_agribusiness_rate",       precision: 8, scale: 2
    t.decimal  "basic_propertyless_member_rate", precision: 8, scale: 2
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
  end

  create_table "unity_suspension_reasons", force: :cascade do |t|
    t.integer  "unity_suspension_id"
    t.integer  "unity_suspension_type_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "unity_suspension_reasons", ["unity_suspension_id"], name: "index_unity_suspension_reasons_on_unity_suspension_id", using: :btree
  add_index "unity_suspension_reasons", ["unity_suspension_type_id"], name: "index_unity_suspension_reasons_on_unity_suspension_type_id", using: :btree

  create_table "unity_suspension_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "unity_suspensions", force: :cascade do |t|
    t.string   "description"
    t.date     "suspension_date"
    t.integer  "production_unity_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "suspension_type"
  end

  add_index "unity_suspensions", ["production_unity_id"], name: "index_unity_suspensions_on_production_unity_id", using: :btree

  add_foreign_key "certificate_addresses", "certificates"
  add_foreign_key "certificate_families", "certificates"
  add_foreign_key "certificate_families", "farmer_families"
  add_foreign_key "certificate_groups", "cities"
  add_foreign_key "certificate_groups", "groups"
  add_foreign_key "certificate_names", "certificates"
  add_foreign_key "certificate_names", "farmers"
  add_foreign_key "certificate_names", "production_unities"
  add_foreign_key "certificate_products", "certificates"
  add_foreign_key "certificate_products", "products"
  add_foreign_key "certificates", "certificate_groups"
  add_foreign_key "cities", "states"
  add_foreign_key "core_coordinators", "cores"
  add_foreign_key "core_payments", "cores"
  add_foreign_key "cores", "states"
  add_foreign_key "dac_documents", "groups"
  add_foreign_key "dacs", "farmers"
  add_foreign_key "daps", "farmers"
  add_foreign_key "document_sended_histories", "document_sendeds"
  add_foreign_key "document_sended_statuses", "document_sendeds"
  add_foreign_key "document_sendeds", "documents"
  add_foreign_key "farmer_families", "farmers"
  add_foreign_key "farmer_group_changes", "farmers"
  add_foreign_key "farmer_group_changes", "groups"
  add_foreign_key "farmer_suspension_reasons", "farmer_suspensions"
  add_foreign_key "farmer_suspension_reasons", "suspension_types"
  add_foreign_key "farmer_suspensions", "farmers"
  add_foreign_key "farmers", "cities"
  add_foreign_key "farmers", "groups"
  add_foreign_key "groups", "cores"
  add_foreign_key "groups", "group_types"
  add_foreign_key "product_categories", "scopes"
  add_foreign_key "production_unities", "cities"
  add_foreign_key "production_unities", "groups"
  add_foreign_key "production_unity_farmers", "farmers"
  add_foreign_key "production_unity_farmers", "production_unities"
  add_foreign_key "production_unity_scopes", "production_unities"
  add_foreign_key "production_unity_scopes", "scopes"
  add_foreign_key "products", "product_categories"
  add_foreign_key "scope_products", "production_unity_scopes"
  add_foreign_key "scope_products", "products"
  add_foreign_key "set_suplentes", "farmers"
  add_foreign_key "set_suplentes", "groups"
  add_foreign_key "sigorg_changes", "sigorgs"
  add_foreign_key "sigorgs", "farmers"
  add_foreign_key "sigorgs", "production_unities"
  add_foreign_key "unity_suspension_reasons", "unity_suspension_types"
  add_foreign_key "unity_suspension_reasons", "unity_suspensions"
  add_foreign_key "unity_suspensions", "production_unities"
end
