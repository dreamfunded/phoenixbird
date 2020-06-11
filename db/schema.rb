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

ActiveRecord::Schema.define(version: 20200417234848) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body"
    t.string   "resource_id",   limit: 255, null: false
    t.string   "resource_type", limit: 255, null: false
    t.integer  "author_id"
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "bids", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "auction_id",       limit: 255
    t.boolean  "accepted"
    t.integer  "company_id"
    t.integer  "number_of_shares"
    t.integer  "user_id"
    t.string   "status",           limit: 255, default: "pending"
    t.float    "bid_amount"
    t.integer  "counter_amount",               default: 0
  end

  create_table "campaign_events", force: :cascade do |t|
    t.string   "state",       limit: 255
    t.integer  "campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "campaign_events", ["campaign_id"], name: "index_campaign_events_on_campaign_id", using: :btree

  create_table "campaign_quotes", force: :cascade do |t|
    t.string   "said_by",            limit: 255
    t.string   "position",           limit: 255
    t.string   "main",               limit: 255
    t.integer  "campaign_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name",    limit: 255
    t.string   "photo_content_type", limit: 255
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "company_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.integer "company_id"
    t.integer "funding_goal"
    t.text    "tagline"
    t.string  "category",                   limit: 255
    t.text    "elevator_pitch"
    t.text    "tags"
    t.text    "about_campaign"
    t.integer "employees_numer"
    t.string  "legal_company_name",         limit: 255
    t.string  "employer_id_number",         limit: 255
    t.string  "state_where_incorporated",   limit: 255
    t.string  "office_location",            limit: 255
    t.date    "date_formed"
    t.string  "company_location_address",   limit: 255
    t.string  "company_location_city",      limit: 255
    t.string  "company_location_state",     limit: 255
    t.string  "company_location_zipcode",   limit: 255
    t.string  "company_contact_info_name",  limit: 255
    t.string  "company_contact_info_email", limit: 255
    t.string  "company_contact_info_phone", limit: 255
    t.string  "legal_contact_info_name",    limit: 255
    t.string  "legal_contact_info_email",   limit: 255
    t.string  "legal_contact_info_phone",   limit: 255
    t.string  "legal_contact_info_firm",    limit: 255
    t.string  "legal_contact_info_website", limit: 255
    t.string  "accounting_info_name",       limit: 255
    t.string  "accounting_info_email",      limit: 255
    t.string  "accounting_info_phone",      limit: 255
    t.string  "accounting_info_firm",       limit: 255
    t.string  "accounting_info_website",    limit: 255
    t.string  "state_filing_number",        limit: 255
    t.text    "offering_terms"
    t.text    "financial_risks"
    t.integer "totat_income"
    t.integer "total_taxable_income"
    t.integer "total_taxes_paid"
    t.text    "business_plan"
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",    limit: 255, null: false
    t.string   "data_content_type", limit: 255
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "co_founders", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "parent_id"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comment_id"
    t.boolean  "reply"
    t.string   "ancestry",   limit: 255
    t.integer  "group_id"
  end

  add_index "comments", ["ancestry"], name: "index_comments_on_ancestry", using: :btree

  create_table "companies", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name",                   limit: 255
    t.text     "description"
    t.integer  "invested_amount",                    default: 0
    t.string   "website_link",           limit: 255
    t.string   "video_link",             limit: 255, default: ""
    t.integer  "goal_amount"
    t.integer  "status"
    t.string   "CEO",                    limit: 255
    t.string   "CEO_number",             limit: 255
    t.integer  "display"
    t.integer  "days_left"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name",        limit: 255
    t.string   "image_content_type",     limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "document_file_name",     limit: 255
    t.string   "document_content_type",  limit: 255
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.text     "docusign_url"
    t.integer  "position",                           default: 0
    t.boolean  "hidden",                             default: false
    t.float    "suggested_target_price"
    t.boolean  "accredited"
    t.date     "end_date"
    t.string   "cover_file_name",        limit: 255
    t.string   "cover_content_type",     limit: 255
    t.integer  "cover_file_size"
    t.datetime "cover_updated_at"
    t.string   "slug",                   limit: 255
    t.text     "fund_america_code",                  default: ""
    t.integer  "min_investment",                     default: 100
    t.boolean  "reg_a"
    t.string   "category",               limit: 255
    t.boolean  "real_estate"
  end

  add_index "companies", ["slug"], name: "index_companies_on_slug", using: :btree

  create_table "companies_groups", force: :cascade do |t|
    t.integer "group_id"
    t.integer "company_id"
  end

  create_table "csv_files", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "file_file_name",    limit: 255
    t.string   "file_content_type", limit: 255
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",               default: 0, null: false
    t.integer  "attempts",               default: 0, null: false
    t.text     "handler",                            null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "documents", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "name",              limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name",    limit: 255
    t.string   "file_content_type", limit: 255
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "docusigns", force: :cascade do |t|
    t.string  "envelope_id", limit: 255
    t.integer "user_id"
    t.integer "company_id"
  end

  create_table "events", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "location",           limit: 255
    t.text     "description"
    t.date     "date"
    t.string   "link",               limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "financial_details", force: :cascade do |t|
    t.text     "offering_terms"
    t.text     "fin_risks"
    t.text     "income"
    t.integer  "totat_income"
    t.integer  "total_taxable_income"
    t.integer  "total_taxes_paid"
    t.integer  "total_assets_this_year"
    t.integer  "total_assets_last_year"
    t.integer  "cash_this_year"
    t.integer  "cash_last_year"
    t.integer  "acount_receivable_this_year"
    t.integer  "acount_receivable_last_year"
    t.integer  "short_term_debt_this_year"
    t.integer  "short_term_debt_last_year"
    t.integer  "long_term_debt_this_year"
    t.integer  "long_term_debt_last_year"
    t.integer  "sales_this_year"
    t.integer  "sales_last_year"
    t.integer  "costs_of_goods_this_year"
    t.integer  "costs_of_goods_last_year"
    t.integer  "taxes_paid_this_year"
    t.integer  "taxes_paid_last_year"
    t.integer  "net_income_this_year"
    t.integer  "net_income_last_year"
    t.integer  "company_id"
    t.string   "balance_sheet_file_name",                  limit: 255
    t.string   "balance_sheet_content_type",               limit: 255
    t.integer  "balance_sheet_file_size"
    t.datetime "balance_sheet_updated_at"
    t.string   "income_statements_file_name",              limit: 255
    t.string   "income_statements_content_type",           limit: 255
    t.integer  "income_statements_file_size"
    t.datetime "income_statements_updated_at"
    t.string   "statement_of_cash_flow_file_name",         limit: 255
    t.string   "statement_of_cash_flow_content_type",      limit: 255
    t.integer  "statement_of_cash_flow_file_size"
    t.datetime "statement_of_cash_flow_updated_at"
    t.string   "statement_changes_of_equity_file_name",    limit: 255
    t.string   "statement_changes_of_equity_content_type", limit: 255
    t.integer  "statement_changes_of_equity_file_size"
    t.datetime "statement_changes_of_equity_updated_at"
    t.string   "business_plan_file_name",                  limit: 255
    t.string   "business_plan_content_type",               limit: 255
    t.integer  "business_plan_file_size"
    t.datetime "business_plan_updated_at"
    t.string   "party_transaction_file_name",              limit: 255
    t.string   "party_transaction_content_type",           limit: 255
    t.integer  "party_transaction_file_size"
    t.datetime "party_transaction_updated_at"
    t.string   "intended_use_of_proceeds_file_name",       limit: 255
    t.string   "intended_use_of_proceeds_content_type",    limit: 255
    t.integer  "intended_use_of_proceeds_file_size"
    t.datetime "intended_use_of_proceeds_updated_at"
    t.string   "capital_structure_file_name",              limit: 255
    t.string   "capital_structure_content_type",           limit: 255
    t.integer  "capital_structure_file_size"
    t.datetime "capital_structure_updated_at"
    t.string   "material_terms_file_name",                 limit: 255
    t.string   "material_terms_content_type",              limit: 255
    t.integer  "material_terms_file_size"
    t.datetime "material_terms_updated_at"
    t.string   "financial_conditions_file_name",           limit: 255
    t.string   "financial_conditions_content_type",        limit: 255
    t.integer  "financial_conditions_file_size"
    t.datetime "financial_conditions_updated_at"
    t.string   "directors_background_file_name",           limit: 255
    t.string   "directors_background_content_type",        limit: 255
    t.integer  "directors_background_file_size"
    t.datetime "directors_background_updated_at"
    t.string   "accountant_review_file_name",              limit: 255
    t.string   "accountant_review_content_type",           limit: 255
    t.integer  "accountant_review_file_size"
    t.datetime "accountant_review_updated_at"
    t.integer  "general_info_id"
    t.decimal  "sustain_amount"
  end

  create_table "followers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "founders", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "position",           limit: 255
    t.string   "image_address",      limit: 255
    t.text     "content"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "title",              limit: 255
  end

  create_table "fundraise_tiers", force: :cascade do |t|
    t.string   "amount",          limit: 255
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "general_info_id"
  end

  create_table "general_infos", force: :cascade do |t|
    t.string   "name",                          limit: 255
    t.string   "kind",                          limit: 255
    t.string   "state",                         limit: 255
    t.date     "date_formed"
    t.integer  "employees_numer"
    t.string   "company_location_address",      limit: 255
    t.string   "company_location_state",        limit: 255
    t.string   "company_location_zipcode",      limit: 255
    t.string   "website",                       limit: 255
    t.string   "employer_id_number",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "company_location_city",         limit: 255
    t.string   "cap_table_file_name",           limit: 255
    t.string   "cap_table_content_type",        limit: 255
    t.integer  "cap_table_file_size"
    t.datetime "cap_table_updated_at"
    t.text     "outstanding_loan"
    t.text     "financial_condition"
    t.integer  "company_id"
    t.text     "business_model"
    t.text     "business_plan"
    t.text     "business_history"
    t.text     "product_description"
    t.text     "competition"
    t.text     "customer_base"
    t.text     "intellectual_property"
    t.text     "governmental_regulatory"
    t.text     "litigation"
    t.text     "phone"
    t.integer  "days"
    t.boolean  "completed",                                 default: false
    t.string   "max_amount",                    limit: 255
    t.string   "type_of_securtity",             limit: 255
    t.text     "legal_name"
    t.string   "position_title",                limit: 255
    t.date     "first_date"
    t.text     "prev_emp"
    t.string   "prev_title",                    limit: 255
    t.string   "prev_dates",                    limit: 255
    t.text     "prev_resp"
    t.text     "offering_purpose"
    t.text     "fin_condition"
    t.string   "number_of_securities",          limit: 255
    t.string   "price_of_securities",           limit: 255
    t.string   "min_amount",                    limit: 255
    t.string   "min_investment",                limit: 255
    t.text     "maket_strategy"
    t.text     "company_description"
    t.string   "discount",                      limit: 255
    t.string   "ceo",                           limit: 255
    t.string   "rds",                           limit: 255
    t.string   "rds_years",                     limit: 255
    t.string   "upcoming_rd",                   limit: 255
    t.text     "real_estate"
    t.string   "valuation",                     limit: 255
    t.string   "burn_rate",                     limit: 255
    t.boolean  "additional_financing"
    t.boolean  "additional_sources_capital"
    t.boolean  "additional_sources_necessary"
    t.boolean  "has_material_capital"
    t.text     "material_capital"
    t.text     "material_capital_expenditures"
    t.text     "transactin"
    t.text     "related_person"
    t.text     "conflicts"
  end

  create_table "group_admins", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.text     "bio"
    t.integer  "group_id"
    t.integer  "user_id"
    t.string   "photo_file_name",    limit: 255
    t.string   "photo_content_type", limit: 255
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "email",              limit: 255
  end

  create_table "group_invites", force: :cascade do |t|
    t.integer  "group_id"
    t.string   "email",      limit: 255
    t.string   "token",      limit: 255
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name",                    limit: 255
    t.text     "description"
    t.string   "image_file_name",         limit: 255
    t.string   "image_content_type",      limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "background_file_name",    limit: 255
    t.string   "background_content_type", limit: 255
    t.integer  "background_file_size"
    t.datetime "background_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug",                    limit: 255
    t.integer  "member"
  end

  add_index "groups", ["slug"], name: "index_groups_on_slug", using: :btree

  create_table "groups_users", id: false, force: :cascade do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  add_index "groups_users", ["group_id"], name: "index_groups_users_on_group_id", using: :btree
  add_index "groups_users", ["user_id"], name: "index_groups_users_on_user_id", using: :btree

  create_table "guests", force: :cascade do |t|
    t.string   "email",           limit: 255
    t.string   "newsletter_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "company",         limit: 255
    t.string   "name",            limit: 255
  end

  create_table "investment_perks", force: :cascade do |t|
    t.text     "content"
    t.string   "amount",          limit: 255
    t.integer  "general_info_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "investments", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "invested_amount",              default: 0
    t.integer  "number_of_shares"
    t.string   "fund_america_id",  limit: 255
  end

  add_index "investments", ["company_id"], name: "index_investments_on_company_id", using: :btree
  add_index "investments", ["user_id"], name: "index_investments_on_user_id", using: :btree

  create_table "investors", force: :cascade do |t|
    t.integer  "annual_income"
    t.integer  "new_worth"
    t.boolean  "us_citizen"
    t.boolean  "exempt_withholding"
    t.string   "ssn",                limit: 255
    t.string   "country",            limit: 255
    t.date     "date_of_birth"
    t.text     "address"
    t.string   "city",               limit: 255
    t.string   "state",              limit: 255
    t.string   "zipcode",            limit: 255
    t.integer  "user_id"
    t.string   "drive_license",      limit: 255
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "invites", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "email",             limit: 255
    t.string   "token",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "accepted"
    t.boolean  "signedup"
    t.string   "status",            limit: 255, default: "Hasn't signed up yet"
    t.string   "name",              limit: 255
    t.string   "file_file_name",    limit: 255
    t.string   "file_content_type", limit: 255
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "group_id"
  end

  create_table "liquidate_shares", force: :cascade do |t|
    t.string   "first_name",             limit: 255
    t.string   "company",                limit: 255
    t.integer  "number_shares"
    t.integer  "shares_price"
    t.string   "timeframe",              limit: 255
    t.string   "email",                  limit: 255
    t.string   "phone",                  limit: 255
    t.text     "message"
    t.string   "last_name",              limit: 255
    t.boolean  "rofr_restrictions"
    t.boolean  "financial_assistance"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "suggested_target_price"
    t.boolean  "approved"
    t.integer  "user_id"
    t.integer  "company_id"
  end

  create_table "logos", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.text     "info"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "position"
  end

  create_table "members", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.text     "summary"
    t.text     "fullbio"
    t.string   "title",              limit: 255
    t.integer  "rank"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "slug",               limit: 255
  end

  add_index "members", ["slug"], name: "index_members_on_slug", using: :btree

  create_table "news", force: :cascade do |t|
    t.text     "title"
    t.string   "image_filename",     limit: 255
    t.text     "content"
    t.text     "source"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "slug",               limit: 255
    t.integer  "position",                       default: 0
    t.string   "video_link",         limit: 255, default: ""
    t.string   "source_url",         limit: 255
  end

  add_index "news", ["slug"], name: "index_news_on_slug", using: :btree

  create_table "officers", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.string   "year_joined",     limit: 255
    t.boolean  "officers"
    t.boolean  "director"
    t.text     "position"
    t.text     "occupation"
    t.string   "main_employer",   limit: 255
    t.integer  "general_info_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "education",       limit: 255
    t.text     "employment"
  end

  create_table "paragraphs", force: :cascade do |t|
    t.string  "page",     limit: 255
    t.text    "title"
    t.text    "content"
    t.integer "position"
  end

  create_table "posts", force: :cascade do |t|
    t.text     "content"
    t.text     "title"
    t.string   "source",             limit: 255
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",                       default: 0
    t.string   "page",               limit: 255
    t.string   "slug",               limit: 255
  end

  add_index "posts", ["slug"], name: "index_posts_on_slug", using: :btree

  create_table "press_posts", force: :cascade do |t|
    t.datetime "date"
    t.text     "name"
    t.string   "source",             limit: 255
    t.text     "url"
    t.text     "quote"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "principal_holders", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.text     "securities_held"
    t.string   "voting_power",    limit: 255
    t.integer  "general_info_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",           limit: 255
  end

  create_table "prospective_investments", force: :cascade do |t|
    t.string   "user_id",           limit: 255
    t.string   "first_name",        limit: 255
    t.string   "last_name",         limit: 255
    t.string   "email",             limit: 255
    t.string   "phone",             limit: 255
    t.string   "company",           limit: 255
    t.string   "company_id",        limit: 255
    t.string   "investment_amount", limit: 255
    t.float    "shares_price"
    t.string   "message",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", force: :cascade do |t|
    t.text    "answer"
    t.integer "company_id"
    t.text    "question"
  end

  create_table "risks", force: :cascade do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "general_info_id"
  end

  create_table "sections", force: :cascade do |t|
    t.integer  "company_id"
    t.text     "overview"
    t.text     "target_market"
    t.text     "current_investor_details"
    t.text     "detailed_metrics"
    t.text     "customer_testimonials"
    t.text     "competitive_landscape"
    t.text     "planned_use_of_funds"
    t.text     "pitch_deck"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "securities", force: :cascade do |t|
    t.string   "security_class",      limit: 255
    t.string   "amount",              limit: 255
    t.string   "outstanding",         limit: 255
    t.boolean  "voting_rights"
    t.boolean  "other_rights"
    t.integer  "general_info_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "securities_reserved", limit: 255
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255, null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "supporters", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "file_name",          limit: 255
    t.text     "summary"
    t.text     "fullbio"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "title",              limit: 255
    t.string   "slug",               limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["slug"], name: "index_teams_on_slug", using: :btree

  create_table "terms", force: :cascade do |t|
    t.string   "safe_cap",            limit: 255
    t.string   "valuation_cap",       limit: 255
    t.string   "investor_threshold",  limit: 255
    t.boolean  "pro_rata?"
    t.string   "governing_law_state", limit: 255
    t.integer  "days"
    t.string   "raised_this_round",   limit: 255
    t.integer  "discount"
    t.integer  "store_credit"
    t.integer  "store_discount"
    t.integer  "general_info_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "testimonials", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "position",           limit: 255
    t.text     "message"
    t.integer  "campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name",    limit: 255
    t.string   "photo_content_type", limit: 255
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "timeline_items", force: :cascade do |t|
    t.text     "content"
    t.date     "created_date"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "position"
    t.integer  "company_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "login",                  limit: 255
    t.string   "email",                  limit: 255
    t.integer  "authority"
    t.string   "salt",                   limit: 255
    t.boolean  "confirmed",                          default: false
    t.string   "slug",                   limit: 255
    t.integer  "invested_amount",                    default: 0
    t.string   "phone",                  limit: 255
    t.string   "uid",                    limit: 255
    t.string   "provider",               limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",                   limit: 255
    t.integer  "credit",                             default: 0
    t.integer  "invite_credit",                      default: 0
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "company_id"
    t.boolean  "advisor"
    t.string   "image_file_name",        limit: 255
    t.string   "image_content_type",     limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "title",                  limit: 255
    t.text     "bio"
    t.integer  "position",                           default: 0
    t.string   "entity_id",              limit: 255
    t.string   "ach_id",                 limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", using: :btree

end
