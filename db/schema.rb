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

ActiveRecord::Schema.define(version: 20170720073631) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"

  create_table "activities", force: :cascade do |t|
    t.string   "trackable_type"
    t.integer  "trackable_id"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.string   "key"
    t.text     "parameters"
    t.string   "recipient_type"
    t.integer  "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published",      default: true,  null: false
    t.boolean  "private",        default: false, null: false
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
    t.index ["private"], name: "index_activities_on_private", using: :btree
    t.index ["published"], name: "index_activities_on_published", using: :btree
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree
  end

  create_table "analytics_events", force: :cascade do |t|
    t.string   "event_id",                null: false
    t.citext   "key",                     null: false
    t.jsonb    "data",       default: {}, null: false
    t.datetime "timestamp",               null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "user_id"
    t.index ["event_id"], name: "index_analytics_events_on_event_id", unique: true, using: :btree
    t.index ["key"], name: "index_analytics_events_on_key", using: :btree
    t.index ["timestamp"], name: "index_analytics_events_on_timestamp", using: :btree
    t.index ["user_id"], name: "index_analytics_events_on_user_id", using: :btree
  end

  create_table "appointment_categories", force: :cascade do |t|
    t.string   "name",        null: false
    t.citext   "slug",        null: false
    t.text     "description"
    t.string   "image_uid"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["name"], name: "index_appointment_categories_on_name", unique: true, using: :btree
    t.index ["slug"], name: "index_appointment_categories_on_slug", unique: true, using: :btree
  end

  create_table "appointment_messages", force: :cascade do |t|
    t.integer  "user_id",        null: false
    t.integer  "appointment_id", null: false
    t.text     "text",           null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["appointment_id"], name: "index_appointment_messages_on_appointment_id", using: :btree
    t.index ["user_id"], name: "index_appointment_messages_on_user_id", using: :btree
  end

  create_table "appointment_type_providers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "appointment_type_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["appointment_type_id"], name: "index_appointment_type_providers_on_appointment_type_id", using: :btree
    t.index ["user_id"], name: "index_appointment_type_providers_on_user_id", using: :btree
  end

  create_table "appointment_types", force: :cascade do |t|
    t.string   "name",                                null: false
    t.text     "description"
    t.integer  "duration",                default: 0
    t.integer  "price_cents",             default: 0
    t.string   "acuity_id",                           null: false
    t.integer  "appointment_category_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["acuity_id"], name: "index_appointment_types_on_acuity_id", unique: true, using: :btree
    t.index ["appointment_category_id"], name: "index_appointment_types_on_appointment_category_id", using: :btree
  end

  create_table "appointments", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "acuity_id",                       null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "email"
    t.integer  "price_cents",         default: 0
    t.integer  "amount_paid_cents",   default: 0
    t.integer  "appointment_type_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "timezone"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.datetime "canceled_at"
    t.index ["acuity_id"], name: "index_appointments_on_acuity_id", unique: true, using: :btree
    t.index ["appointment_type_id"], name: "index_appointments_on_appointment_type_id", using: :btree
    t.index ["end_time"], name: "index_appointments_on_end_time", using: :btree
    t.index ["start_time"], name: "index_appointments_on_start_time", using: :btree
    t.index ["user_id"], name: "index_appointments_on_user_id", using: :btree
  end

  create_table "authentications", force: :cascade do |t|
    t.string   "provider",      null: false
    t.string   "uid",           null: false
    t.integer  "user_id",       null: false
    t.text     "token"
    t.text     "refresh_token"
    t.string   "secret"
    t.boolean  "expires"
    t.datetime "expires_at"
    t.json     "omniauth_json"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "username"
    t.index ["provider", "uid"], name: "index_authentications_on_provider_and_uid", unique: true, using: :btree
    t.index ["provider"], name: "index_authentications_on_provider", using: :btree
    t.index ["user_id"], name: "index_authentications_on_user_id", using: :btree
  end

  create_table "badges", force: :cascade do |t|
    t.citext   "name",                    null: false
    t.citext   "slug",                    null: false
    t.string   "avatar_uid"
    t.string   "description"
    t.string   "earned_by"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "position",    default: 0, null: false
    t.index ["name"], name: "index_badges_on_name", unique: true, using: :btree
    t.index ["slug"], name: "index_badges_on_slug", unique: true, using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.text     "text",                         null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "likes_count",      default: 0, null: false
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "communities", force: :cascade do |t|
    t.citext   "name",                      null: false
    t.citext   "slug",                      null: false
    t.string   "avatar_uid"
    t.text     "description"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "members_count", default: 0, null: false
    t.index ["name"], name: "index_communities_on_name", unique: true, using: :btree
    t.index ["slug"], name: "index_communities_on_slug", unique: true, using: :btree
  end

  create_table "community_invites", force: :cascade do |t|
    t.integer  "community_id", null: false
    t.integer  "sender_id",    null: false
    t.integer  "user_id",      null: false
    t.string   "slug",         null: false
    t.datetime "accepted_on"
    t.datetime "declined_on"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["community_id", "sender_id", "user_id"], name: "sender_user", unique: true, using: :btree
    t.index ["community_id"], name: "index_community_invites_on_community_id", using: :btree
    t.index ["sender_id"], name: "index_community_invites_on_sender_id", using: :btree
    t.index ["slug"], name: "index_community_invites_on_slug", unique: true, using: :btree
    t.index ["user_id"], name: "index_community_invites_on_user_id", using: :btree
  end

  create_table "community_members", force: :cascade do |t|
    t.integer  "community_id", null: false
    t.integer  "user_id",      null: false
    t.string   "role",         null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["community_id"], name: "index_community_members_on_community_id", using: :btree
    t.index ["role"], name: "index_community_members_on_role", using: :btree
    t.index ["user_id", "community_id"], name: "index_community_members_on_user_id_and_community_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_community_members_on_user_id", using: :btree
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name",                               null: false
    t.citext   "slug",                               null: false
    t.string   "avatar_uid"
    t.string   "logo_uid"
    t.string   "twitter_url"
    t.string   "facebook_url"
    t.string   "instagram_url"
    t.string   "angellist_url"
    t.string   "website_url"
    t.string   "tagline"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "facebook_id"
    t.integer  "added_by_id"
    t.string   "tags",                  default: [],              array: true
    t.integer  "followers_count_cache", default: 0,  null: false
    t.index ["added_by_id"], name: "index_companies_on_added_by_id", using: :btree
    t.index ["facebook_id"], name: "index_companies_on_facebook_id", unique: true, using: :btree
    t.index ["slug"], name: "index_companies_on_slug", unique: true, using: :btree
    t.index ["tags"], name: "index_companies_on_tags", using: :gin
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "email",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_contacts_on_email", unique: true, using: :btree
  end

  create_table "conversation_users", force: :cascade do |t|
    t.integer  "conversation_id"
    t.integer  "user_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "unread_messages_count", default: 0,     null: false
    t.datetime "last_read_at"
    t.boolean  "unread_notified",       default: false, null: false
    t.index ["conversation_id", "user_id"], name: "index_conversation_users_on_conversation_id_and_user_id", unique: true, using: :btree
    t.index ["conversation_id"], name: "index_conversation_users_on_conversation_id", using: :btree
    t.index ["unread_notified"], name: "index_conversation_users_on_unread_notified", using: :btree
    t.index ["user_id"], name: "index_conversation_users_on_user_id", using: :btree
  end

  create_table "conversations", force: :cascade do |t|
    t.string   "slug",                       null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.citext   "key"
    t.integer  "messages_count", default: 0, null: false
    t.index ["key"], name: "index_conversations_on_key", unique: true, using: :btree
    t.index ["slug"], name: "index_conversations_on_slug", unique: true, using: :btree
  end

  create_table "facebook_posts", force: :cascade do |t|
    t.string   "facebook_post_id",  null: false
    t.string   "facebook_group_id"
    t.text     "message"
    t.string   "author_name"
    t.string   "author_fb_id"
    t.text     "link"
    t.string   "post_type"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["facebook_post_id"], name: "index_facebook_posts_on_facebook_post_id", unique: true, using: :btree
  end

  create_table "follows", force: :cascade do |t|
    t.string   "followable_type"
    t.integer  "followable_id",                   null: false
    t.string   "follower_type"
    t.integer  "follower_id",                     null: false
    t.boolean  "blocked",         default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["followable_id", "followable_type"], name: "fk_followables", using: :btree
    t.index ["follower_id", "follower_type"], name: "fk_follows", using: :btree
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "impressions", force: :cascade do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.text     "params"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
    t.index ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
    t.index ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
    t.index ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
    t.index ["impressionable_type", "impressionable_id", "params"], name: "poly_params_request_index", using: :btree
    t.index ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
    t.index ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
    t.index ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", using: :btree
    t.index ["user_id"], name: "index_impressions_on_user_id", using: :btree
  end

  create_table "invites", force: :cascade do |t|
    t.integer  "user_id",      null: false
    t.string   "input",        null: false
    t.string   "slug",         null: false
    t.datetime "viewed_on"
    t.text     "text"
    t.integer  "viewed_by_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "recipient_id"
    t.integer  "contact_id"
    t.index ["contact_id"], name: "index_invites_on_contact_id", using: :btree
    t.index ["recipient_id"], name: "index_invites_on_recipient_id", using: :btree
    t.index ["slug"], name: "index_invites_on_slug", unique: true, using: :btree
    t.index ["user_id"], name: "index_invites_on_user_id", using: :btree
    t.index ["viewed_by_id"], name: "index_invites_on_viewed_by_id", using: :btree
    t.index ["viewed_on"], name: "index_invites_on_viewed_on", using: :btree
  end

  create_table "job_referrals", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "job_id",     null: false
    t.integer  "sender_id"
    t.string   "slug",       null: false
    t.datetime "viewed_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_job_referrals_on_job_id", using: :btree
    t.index ["sender_id", "user_id", "job_id"], name: "job_user_sender", unique: true, using: :btree
    t.index ["sender_id"], name: "index_job_referrals_on_sender_id", using: :btree
    t.index ["slug"], name: "index_job_referrals_on_slug", unique: true, using: :btree
    t.index ["user_id"], name: "index_job_referrals_on_user_id", using: :btree
    t.index ["viewed_on"], name: "index_job_referrals_on_viewed_on", using: :btree
  end

  create_table "job_scores", force: :cascade do |t|
    t.integer  "user_id",                null: false
    t.integer  "job_id",                 null: false
    t.integer  "score",      default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["job_id"], name: "index_job_scores_on_job_id", using: :btree
    t.index ["user_id", "job_id"], name: "index_job_scores_on_user_id_and_job_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_job_scores_on_user_id", using: :btree
  end

  create_table "jobs", force: :cascade do |t|
    t.string   "name",                             null: false
    t.citext   "slug",                             null: false
    t.integer  "company_id",                       null: false
    t.integer  "user_id",                          null: false
    t.text     "description"
    t.string   "link"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "full_time",        default: true,  null: false
    t.boolean  "part_time",        default: false, null: false
    t.boolean  "remote",           default: false, null: false
    t.boolean  "contract",         default: false, null: false
    t.boolean  "internship",       default: false, null: false
    t.integer  "location_id",                      null: false
    t.integer  "role_id"
    t.string   "skills",           default: [],                 array: true
    t.integer  "likes_count",      default: 0,     null: false
    t.datetime "published_on"
    t.string   "suggested_skills", default: [],                 array: true
    t.index ["company_id"], name: "index_jobs_on_company_id", using: :btree
    t.index ["contract"], name: "index_jobs_on_contract", using: :btree
    t.index ["full_time"], name: "index_jobs_on_full_time", using: :btree
    t.index ["internship"], name: "index_jobs_on_internship", using: :btree
    t.index ["location_id"], name: "index_jobs_on_location_id", using: :btree
    t.index ["part_time"], name: "index_jobs_on_part_time", using: :btree
    t.index ["published_on"], name: "index_jobs_on_published_on", using: :btree
    t.index ["remote"], name: "index_jobs_on_remote", using: :btree
    t.index ["role_id"], name: "index_jobs_on_role_id", using: :btree
    t.index ["skills"], name: "index_jobs_on_skills", using: :gin
    t.index ["slug"], name: "index_jobs_on_slug", unique: true, using: :btree
    t.index ["suggested_skills"], name: "index_jobs_on_suggested_skills", using: :gin
    t.index ["user_id"], name: "index_jobs_on_user_id", using: :btree
  end

  create_table "likes", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "likeable_type"
    t.integer  "likeable_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable_type_and_likeable_id", using: :btree
    t.index ["user_id", "likeable_type", "likeable_id"], name: "index_likes_on_user_id_and_likeable_type_and_likeable_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_likes_on_user_id", using: :btree
  end

  create_table "locations", force: :cascade do |t|
    t.string   "name",                            null: false
    t.citext   "slug",                            null: false
    t.string   "level"
    t.string   "short"
    t.integer  "parent_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "users_count",         default: 0, null: false
    t.string   "facebook_id"
    t.string   "cached_display_name"
    t.float    "latitude"
    t.float    "longitude"
    t.index ["facebook_id"], name: "index_locations_on_facebook_id", unique: true, using: :btree
    t.index ["parent_id", "name"], name: "index_locations_on_parent_id_and_name", unique: true, using: :btree
    t.index ["parent_id", "slug"], name: "index_locations_on_parent_id_and_slug", unique: true, using: :btree
    t.index ["parent_id"], name: "index_locations_on_parent_id", using: :btree
  end

  create_table "mentions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "mentionable_type"
    t.integer  "mentionable_id"
    t.integer  "sender_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["mentionable_type", "mentionable_id"], name: "index_mentions_on_mentionable_type_and_mentionable_id", using: :btree
    t.index ["sender_id"], name: "index_mentions_on_sender_id", using: :btree
    t.index ["user_id", "mentionable_type", "mentionable_id"], name: "user_mentions", unique: true, using: :btree
    t.index ["user_id"], name: "index_mentions_on_user_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "conversation_id"
    t.string   "text",            null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "email_job_id"
    t.index ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree
    t.index ["user_id"], name: "index_messages_on_user_id", using: :btree
  end

  create_table "milestones", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name",                         null: false
    t.date     "start_date",                   null: false
    t.date     "end_date"
    t.string   "link"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.text     "description"
    t.integer  "company_id"
    t.integer  "likes_count", default: 0,      null: false
    t.boolean  "printable",   default: true,   null: false
    t.string   "facebook_id"
    t.string   "kind",        default: "work"
    t.string   "skills",      default: [],                  array: true
    t.index ["company_id"], name: "index_milestones_on_company_id", using: :btree
    t.index ["facebook_id"], name: "index_milestones_on_facebook_id", unique: true, using: :btree
    t.index ["kind"], name: "index_milestones_on_kind", using: :btree
    t.index ["printable"], name: "index_milestones_on_printable", using: :btree
    t.index ["skills"], name: "index_milestones_on_skills", using: :gin
    t.index ["start_date"], name: "index_milestones_on_start_date", using: :btree
    t.index ["user_id"], name: "index_milestones_on_user_id", using: :btree
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "activity_id"
    t.string   "activity_key",                null: false
    t.datetime "read_at"
    t.boolean  "published",    default: true, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["activity_id"], name: "index_notifications_on_activity_id", using: :btree
    t.index ["activity_key"], name: "index_notifications_on_activity_key", using: :btree
    t.index ["published"], name: "index_notifications_on_published", using: :btree
    t.index ["read_at"], name: "index_notifications_on_read_at", using: :btree
    t.index ["user_id", "activity_id"], name: "index_notifications_on_user_id_and_activity_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_notifications_on_user_id", using: :btree
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.string   "searchable_type"
    t.integer  "searchable_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id", using: :btree
  end

  create_table "placements", force: :cascade do |t|
    t.string   "placeable_type"
    t.integer  "placeable_id",                null: false
    t.datetime "start_time",                  null: false
    t.datetime "end_time",                    null: false
    t.integer  "priority",       default: 0,  null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "tags",           default: [],              array: true
    t.index ["end_time"], name: "index_placements_on_end_time", using: :btree
    t.index ["placeable_type", "placeable_id"], name: "index_placements_on_placeable_type_and_placeable_id", using: :btree
    t.index ["start_time"], name: "index_placements_on_start_time", using: :btree
    t.index ["tags"], name: "index_placements_on_tags", using: :gin
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "user_id",      null: false
    t.integer  "community_id", null: false
    t.string   "text",         null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["community_id"], name: "index_posts_on_community_id", using: :btree
    t.index ["user_id"], name: "index_posts_on_user_id", using: :btree
  end

  create_table "preferences", force: :cascade do |t|
    t.integer  "user_id",                         null: false
    t.boolean  "email_on_follow",  default: true, null: false
    t.boolean  "email_on_comment", default: true, null: false
    t.boolean  "email_on_mention", default: true, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "email_on_unread",  default: true, null: false
    t.index ["email_on_comment"], name: "index_preferences_on_email_on_comment", using: :btree
    t.index ["email_on_follow"], name: "index_preferences_on_email_on_follow", using: :btree
    t.index ["email_on_mention"], name: "index_preferences_on_email_on_mention", using: :btree
    t.index ["email_on_unread"], name: "index_preferences_on_email_on_unread", using: :btree
    t.index ["user_id"], name: "index_preferences_on_user_id", unique: true, using: :btree
  end

  create_table "projects", force: :cascade do |t|
    t.integer  "user_id",                   null: false
    t.string   "name",                      null: false
    t.citext   "slug",                      null: false
    t.integer  "position",     default: 0,  null: false
    t.string   "image_uid"
    t.string   "image_name"
    t.integer  "image_width"
    t.integer  "image_height"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "link"
    t.text     "description"
    t.string   "skills",       default: [],              array: true
    t.integer  "likes_count",  default: 0,  null: false
    t.integer  "company_id"
    t.index ["company_id"], name: "index_projects_on_company_id", using: :btree
    t.index ["skills"], name: "index_projects_on_skills", using: :gin
    t.index ["slug"], name: "index_projects_on_slug", unique: true, using: :btree
    t.index ["user_id"], name: "index_projects_on_user_id", using: :btree
  end

  create_table "resumes", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "file_uid"
    t.string   "file_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_resumes_on_user_id", using: :btree
  end

  create_table "review_requests", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.text     "goal",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_review_requests_on_user_id", using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",                    null: false
    t.citext   "slug",                    null: false
    t.integer  "users_count", default: 0, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "parent_id"
    t.index ["name"], name: "index_roles_on_name", unique: true, using: :btree
    t.index ["slug"], name: "index_roles_on_slug", unique: true, using: :btree
  end

  create_table "skills", force: :cascade do |t|
    t.string   "name",                    null: false
    t.citext   "slug",                    null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "users_count", default: 0, null: false
    t.integer  "added_by_id"
    t.index ["added_by_id"], name: "index_skills_on_added_by_id", using: :btree
    t.index ["name"], name: "index_skills_on_name", unique: true, using: :btree
    t.index ["slug"], name: "index_skills_on_slug", unique: true, using: :btree
  end

  create_table "stories", force: :cascade do |t|
    t.integer  "user_id",                   null: false
    t.string   "name",                      null: false
    t.string   "slug",                      null: false
    t.string   "cover_uid"
    t.datetime "published_on"
    t.text     "content"
    t.integer  "likes_count",  default: 0,  null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "tags",         default: [],              array: true
    t.string   "subtitle"
    t.index ["tags"], name: "index_stories_on_tags", using: :gin
    t.index ["user_id"], name: "index_stories_on_user_id", using: :btree
  end

  create_table "user_badges", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "badge_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "likes_count", default: 0, null: false
    t.index ["badge_id"], name: "index_user_badges_on_badge_id", using: :btree
    t.index ["user_id", "badge_id"], name: "index_user_badges_on_user_id_and_badge_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_user_badges_on_user_id", using: :btree
  end

  create_table "user_roles", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.integer  "position",   default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id", using: :btree
    t.index ["user_id", "role_id"], name: "index_user_roles_on_user_id_and_role_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_user_roles_on_user_id", using: :btree
  end

  create_table "user_skills", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "skill_id"
    t.integer  "years",      default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "position",   default: 0, null: false
    t.index ["skill_id"], name: "index_user_skills_on_skill_id", using: :btree
    t.index ["user_id", "skill_id"], name: "index_user_skills_on_user_id_and_skill_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_user_skills_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                        default: "",    null: false
    t.string   "encrypted_password",           default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "name"
    t.boolean  "is_admin",                     default: false, null: false
    t.citext   "username"
    t.string   "avatar_uid"
    t.integer  "location_id"
    t.string   "gender"
    t.integer  "years_experience",             default: 0,     null: false
    t.string   "bio"
    t.string   "website_url"
    t.string   "twitter_url"
    t.string   "dribbble_url"
    t.string   "github_url"
    t.string   "medium_url"
    t.string   "facebook_url"
    t.string   "linkedin_url"
    t.boolean  "is_available",                 default: false, null: false
    t.boolean  "is_hiring",                    default: false, null: false
    t.boolean  "open_to_remote",               default: false, null: false
    t.boolean  "open_to_full_time",            default: false, null: false
    t.boolean  "open_to_part_time",            default: false, null: false
    t.boolean  "open_to_contract",             default: false, null: false
    t.boolean  "open_to_internship",           default: false, null: false
    t.string   "instagram_url"
    t.boolean  "is_moderator",                 default: false, null: false
    t.boolean  "open_to_relocation",           default: false, null: false
    t.string   "imdb_url"
    t.boolean  "is_reviewer",                  default: false, null: false
    t.integer  "company_id"
    t.integer  "unread_messages_count",        default: 0,     null: false
    t.boolean  "open_to_new_opportunities",    default: false, null: false
    t.boolean  "is_us_work_authorized"
    t.boolean  "requires_us_visa_sponsorship"
    t.integer  "followers_count_cache",        default: 0,     null: false
    t.index ["company_id"], name: "index_users_on_company_id", using: :btree
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["gender"], name: "index_users_on_gender", using: :btree
    t.index ["is_admin"], name: "index_users_on_is_admin", using: :btree
    t.index ["is_available"], name: "index_users_on_is_available", using: :btree
    t.index ["is_hiring"], name: "index_users_on_is_hiring", using: :btree
    t.index ["is_us_work_authorized"], name: "index_users_on_is_us_work_authorized", using: :btree
    t.index ["location_id"], name: "index_users_on_location_id", using: :btree
    t.index ["open_to_contract"], name: "index_users_on_open_to_contract", using: :btree
    t.index ["open_to_full_time"], name: "index_users_on_open_to_full_time", using: :btree
    t.index ["open_to_internship"], name: "index_users_on_open_to_internship", using: :btree
    t.index ["open_to_part_time"], name: "index_users_on_open_to_part_time", using: :btree
    t.index ["open_to_remote"], name: "index_users_on_open_to_remote", using: :btree
    t.index ["requires_us_visa_sponsorship"], name: "index_users_on_requires_us_visa_sponsorship", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  add_foreign_key "analytics_events", "users"
  add_foreign_key "appointment_messages", "appointments"
  add_foreign_key "appointment_messages", "users"
  add_foreign_key "appointment_type_providers", "appointment_types"
  add_foreign_key "appointment_type_providers", "users"
  add_foreign_key "appointment_types", "appointment_categories"
  add_foreign_key "appointments", "appointment_types"
  add_foreign_key "appointments", "users"
  add_foreign_key "authentications", "users"
  add_foreign_key "comments", "users"
  add_foreign_key "community_invites", "communities"
  add_foreign_key "community_invites", "users"
  add_foreign_key "community_invites", "users", column: "sender_id"
  add_foreign_key "community_members", "communities"
  add_foreign_key "community_members", "users"
  add_foreign_key "conversation_users", "conversations"
  add_foreign_key "conversation_users", "users"
  add_foreign_key "invites", "contacts"
  add_foreign_key "invites", "users"
  add_foreign_key "job_referrals", "jobs"
  add_foreign_key "job_referrals", "users"
  add_foreign_key "job_referrals", "users", column: "sender_id"
  add_foreign_key "job_scores", "jobs"
  add_foreign_key "job_scores", "users"
  add_foreign_key "jobs", "companies"
  add_foreign_key "jobs", "locations"
  add_foreign_key "jobs", "roles"
  add_foreign_key "jobs", "users"
  add_foreign_key "likes", "users"
  add_foreign_key "mentions", "users"
  add_foreign_key "mentions", "users", column: "sender_id"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users"
  add_foreign_key "milestones", "companies"
  add_foreign_key "milestones", "users"
  add_foreign_key "notifications", "activities"
  add_foreign_key "notifications", "users"
  add_foreign_key "posts", "communities"
  add_foreign_key "posts", "users"
  add_foreign_key "preferences", "users"
  add_foreign_key "projects", "companies"
  add_foreign_key "projects", "users"
  add_foreign_key "resumes", "users"
  add_foreign_key "review_requests", "users"
  add_foreign_key "stories", "users"
  add_foreign_key "user_badges", "badges"
  add_foreign_key "user_badges", "users"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
  add_foreign_key "user_skills", "skills"
  add_foreign_key "user_skills", "users"
  add_foreign_key "users", "companies"
  add_foreign_key "users", "locations"
end
