# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20241223000000) do

  create_table "attachments", :force => true do |t|
    t.integer "entry_id",     :null => false
    t.string  "content_type"
    t.string  "filename",     :null => false
    t.integer "size",         :null => false
    t.string  "type"
    t.string  "metadata"
    t.integer "parent_id"
    t.string  "thumbnail"
    t.integer "width"
    t.integer "height"
    t.integer "user_id",      :null => false
  end

  add_index "attachments", ["entry_id"], :name => "index_attachments_on_entry_id"
  add_index "attachments", ["parent_id"], :name => "index_attachments_on_parent_id"

  create_table "avatars", :force => true do |t|
    t.integer "user_id",      :null => false
    t.string  "content_type"
    t.string  "filename"
    t.integer "size"
    t.integer "position"
    t.integer "parent_id"
    t.string  "thumbnail"
    t.integer "width"
    t.integer "height"
  end

  add_index "avatars", ["parent_id"], :name => "index_avatars_on_parent_id"
  add_index "avatars", ["user_id"], :name => "index_avatars_on_user_id"

  create_table "backgrounds", :force => true do |t|
    t.integer  "user_id",                             :null => false
    t.string   "image_file_name",                     :null => false
    t.datetime "image_updated_at"
    t.text     "image_meta"
    t.boolean  "is_public",        :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "gray_logo",        :default => false, :null => false
  end

  add_index "backgrounds", ["user_id"], :name => "index_backgrounds_on_user_id"

  create_table "bookmarklets", :force => true do |t|
    t.integer  "user_id",                                         :null => false
    t.datetime "created_at",                                      :null => false
    t.string   "name",                                            :null => false
    t.string   "entry_type", :limit => 16, :default => "text",    :null => false
    t.text     "tags"
    t.string   "visibility", :limit => 16, :default => "private", :null => false
    t.boolean  "autosave",                 :default => false,     :null => false
    t.boolean  "is_public",                :default => false,     :null => false
  end

  add_index "bookmarklets", ["is_public", "created_at"], :name => "index_bookmarklets_on_is_public_and_created_at"
  add_index "bookmarklets", ["user_id", "created_at"], :name => "index_bookmarklets_on_user_id_and_created_at"

  create_table "changelogs", :force => true do |t|
    t.integer  "owner_id",                  :null => false
    t.integer  "actor_id"
    t.integer  "object_id"
    t.string   "object_type"
    t.string   "action",                    :null => false
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ip",          :limit => 16
  end

  add_index "changelogs", ["action"], :name => "index_changelogs_on_action"
  add_index "changelogs", ["actor_id", "action"], :name => "index_changelogs_on_actor_id_and_action"
  add_index "changelogs", ["actor_id"], :name => "index_changelogs_on_actor_id"
  add_index "changelogs", ["ip"], :name => "index_changelogs_on_ip"
  add_index "changelogs", ["object_id", "object_type"], :name => "index_changelogs_on_object_id_and_object_type"
  add_index "changelogs", ["owner_id", "action"], :name => "index_changelogs_on_owner_id_and_action"
  add_index "changelogs", ["owner_id", "ip"], :name => "index_changelogs_on_owner_id_and_ip"
  add_index "changelogs", ["owner_id"], :name => "index_changelogs_on_owner_id"

  create_table "comment_views", :force => true do |t|
    t.integer "entry_id",            :null => false
    t.integer "user_id",             :null => false
    t.integer "last_comment_viewed", :null => false
  end

  add_index "comment_views", ["entry_id", "user_id"], :name => "index_comment_views_on_entry_id_and_user_id", :unique => true

  create_table "comments", :force => true do |t|
    t.integer  "entry_id",                                      :null => false
    t.text     "comment"
    t.integer  "user_id",                                       :null => false
    t.boolean  "is_disabled",                :default => false, :null => false
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at"
    t.text     "comment_html"
    t.string   "remote_ip",    :limit => 17
  end

  add_index "comments", ["created_at"], :name => "index_comments_on_created_at"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "conversations", :force => true do |t|
    t.integer  "user_id",                                 :null => false
    t.integer  "recipient_id",                            :null => false
    t.integer  "messages_count",       :default => 0,     :null => false
    t.boolean  "send_notifications",   :default => true,  :null => false
    t.boolean  "is_replied",           :default => false, :null => false
    t.boolean  "is_viewed",            :default => false, :null => false
    t.integer  "last_message_id"
    t.integer  "last_message_user_id"
    t.datetime "last_message_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_disabled",          :default => false, :null => false
  end

  add_index "conversations", ["is_disabled"], :name => "index_conversations_on_is_disabled"
  add_index "conversations", ["is_replied"], :name => "index_conversations_on_is_replied"
  add_index "conversations", ["is_viewed"], :name => "index_conversations_on_is_viewed"
  add_index "conversations", ["last_message_at"], :name => "index_conversations_on_last_message_at"
  add_index "conversations", ["user_id", "is_replied"], :name => "index_conversations_on_user_id_and_is_replied"
  add_index "conversations", ["user_id", "is_viewed"], :name => "index_conversations_on_user_id_and_is_viewed"
  add_index "conversations", ["user_id", "last_message_at"], :name => "index_conversations_on_user_id_and_last_message_at"
  add_index "conversations", ["user_id", "recipient_id"], :name => "index_conversations_on_user_id_and_recipient_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.string   "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "failed_at"
  end

  add_index "delayed_jobs", ["attempts"], :name => "index_delayed_jobs_on_attempts"
  add_index "delayed_jobs", ["locked_at"], :name => "index_delayed_jobs_on_locked_at"
  add_index "delayed_jobs", ["locked_by"], :name => "index_delayed_jobs_on_locked_by"
  add_index "delayed_jobs", ["priority"], :name => "index_delayed_jobs_on_priority"
  add_index "delayed_jobs", ["run_at"], :name => "index_delayed_jobs_on_run_at"

  create_table "entries", :force => true do |t|
    t.integer  "user_id",                                                :null => false
    t.text     "data_part_1"
    t.text     "data_part_2"
    t.text     "data_part_3"
    t.string   "type",             :limit => 0, :default => "TextEntry", :null => false
    t.boolean  "is_disabled",                   :default => false,       :null => false
    t.datetime "created_at",                                             :null => false
    t.text     "metadata"
    t.integer  "comments_count",                :default => 0,           :null => false
    t.datetime "updated_at"
    t.boolean  "is_voteable",                   :default => false
    t.boolean  "is_private",                    :default => false,       :null => false
    t.text     "cached_tag_list"
    t.boolean  "is_mainpageable",               :default => true,        :null => false
    t.boolean  "comments_enabled",              :default => true,        :null => false
  end

  add_index "entries", ["created_at"], :name => "index_entries_on_created_at"
  add_index "entries", ["is_disabled"], :name => "index_entries_on_is_disabled"
  add_index "entries", ["is_mainpageable", "created_at", "type"], :name => "index_entries_on_is_mainpageable_and_created_at_and_type"
  add_index "entries", ["is_mainpageable", "is_private", "id"], :name => "index_entries_on_is_mainpageable_and_is_private_and_id"
  add_index "entries", ["is_private"], :name => "index_entries_on_is_private"
  add_index "entries", ["is_voteable"], :name => "index_entries_on_is_voteable"
  add_index "entries", ["type"], :name => "index_entries_on_type"
  add_index "entries", ["user_id", "created_at", "type"], :name => "index_entries_on_user_id_and_created_at_and_type"
  add_index "entries", ["user_id", "is_private", "created_at"], :name => "index_entries_on_user_id_and_is_private_and_created_at"
  add_index "entries", ["user_id"], :name => "index_entries_on_user_id"

  create_table "entry_ratings", :force => true do |t|
    t.integer  "entry_id",                                                                       :null => false
    t.string   "entry_type",    :limit => 20,                                                    :null => false
    t.datetime "created_at",                                                                     :null => false
    t.integer  "user_id",                                                                        :null => false
    t.integer  "value",                                                       :default => 0,     :null => false
    t.boolean  "is_great",                                                    :default => false, :null => false
    t.boolean  "is_good",                                                     :default => false, :null => false
    t.boolean  "is_everything",                                               :default => false, :null => false
    t.integer  "ups",                                                         :default => 0,     :null => false
    t.integer  "downs",                                                       :default => 0,     :null => false
    t.decimal  "hotness",                     :precision => 32, :scale => 12, :default => 0.0,   :null => false
    t.boolean  "is_fine",                                                     :default => false, :null => false
  end

  add_index "entry_ratings", ["entry_id"], :name => "index_entry_ratings_on_entry_id", :unique => true
  add_index "entry_ratings", ["entry_type"], :name => "index_entry_ratings_on_entry_type"
  add_index "entry_ratings", ["hotness"], :name => "index_entry_ratings_on_hotness"
  add_index "entry_ratings", ["is_everything", "entry_type"], :name => "index_entry_ratings_on_is_everything_and_entry_type"
  add_index "entry_ratings", ["is_everything"], :name => "index_entry_ratings_on_is_everything"
  add_index "entry_ratings", ["is_fine"], :name => "index_entry_ratings_on_is_fine"
  add_index "entry_ratings", ["is_good", "entry_type"], :name => "index_entry_ratings_on_is_good_and_entry_type"
  add_index "entry_ratings", ["is_good"], :name => "index_entry_ratings_on_is_good"
  add_index "entry_ratings", ["is_great", "entry_type"], :name => "index_entry_ratings_on_is_great_and_entry_type"
  add_index "entry_ratings", ["is_great"], :name => "index_entry_ratings_on_is_great"
  add_index "entry_ratings", ["value", "entry_type"], :name => "index_entry_ratings_on_value_and_entry_type"

  create_table "entry_subscribers", :id => false, :force => true do |t|
    t.integer "entry_id", :null => false
    t.integer "user_id",  :null => false
  end

  add_index "entry_subscribers", ["entry_id", "user_id"], :name => "index_entry_subscribers_on_entry_id_and_user_id", :unique => true

  create_table "entry_votes", :force => true do |t|
    t.integer "entry_id",                :null => false
    t.integer "user_id",                 :null => false
    t.integer "value",    :default => 0, :null => false
  end

  add_index "entry_votes", ["entry_id", "user_id"], :name => "index_entry_votes_on_entry_id_and_user_id", :unique => true

  create_table "faves", :force => true do |t|
    t.integer  "user_id",                     :null => false
    t.integer  "entry_id",                    :null => false
    t.string   "entry_type",    :limit => 64, :null => false
    t.integer  "entry_user_id",               :null => false
    t.datetime "created_at"
  end

  add_index "faves", ["user_id", "entry_id"], :name => "index_faves_on_user_id_and_entry_id", :unique => true
  add_index "faves", ["user_id", "entry_type"], :name => "index_faves_on_user_id_and_entry_type"
  add_index "faves", ["user_id", "entry_user_id"], :name => "index_faves_on_user_id_and_entry_user_id"

  create_table "feedbacks", :force => true do |t|
    t.integer  "user_id",                         :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.text     "message",                         :null => false
    t.boolean  "is_public",    :default => false, :null => false
    t.boolean  "is_moderated", :default => false, :null => false
  end

  add_index "feedbacks", ["is_moderated", "created_at"], :name => "index_feedbacks_on_is_moderated_and_created_at"
  add_index "feedbacks", ["is_public", "created_at"], :name => "index_feedbacks_on_is_public_and_created_at"
  add_index "feedbacks", ["user_id"], :name => "index_feedbacks_on_user_id", :unique => true

  create_table "helps", :force => true do |t|
    t.string   "path",                       :null => false
    t.text     "body"
    t.integer  "impressions", :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", :force => true do |t|
    t.integer  "user_id",                  :null => false
    t.integer  "invitee_id"
    t.string   "email"
    t.string   "code",       :limit => 32
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["code"], :name => "index_invitations_on_code", :unique => true
  add_index "invitations", ["invitee_id"], :name => "index_invitations_on_invitee_id"
  add_index "invitations", ["user_id"], :name => "index_invitations_on_user_id"

  create_table "invoices", :force => true do |t|
    t.integer  "user_id",                     :null => false
    t.string   "state",                       :null => false
    t.string   "type",                        :null => false
    t.string   "metadata",                    :null => false
    t.float    "amount",     :default => 0.0, :null => false
    t.float    "revenue",    :default => 0.0, :null => false
    t.integer  "days",       :default => 0,   :null => false
    t.string   "remote_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invoices", ["user_id"], :name => "index_invoices_on_user_id"

  create_table "messages", :force => true do |t|
    t.integer  "user_id",         :null => false
    t.text     "body",            :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at"
    t.integer  "conversation_id", :null => false
    t.integer  "recipient_id",    :null => false
  end

  add_index "messages", ["user_id"], :name => "index_messages_on_user_id"

  create_table "mobile_settings", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "keyword",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mobile_settings", ["keyword"], :name => "index_mobile_settings_on_keyword", :unique => true
  add_index "mobile_settings", ["user_id"], :name => "index_mobile_settings_on_user_id", :unique => true

  create_table "radio_schedules", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "body",       :null => false
    t.datetime "air_at",     :null => false
    t.datetime "end_at",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relationships", :force => true do |t|
    t.integer  "user_id",                                                 :null => false
    t.integer  "reader_id",                                               :null => false
    t.integer  "position"
    t.integer  "read_count",                               :default => 0, :null => false
    t.datetime "last_read_at"
    t.integer  "comment_count",                            :default => 0, :null => false
    t.datetime "last_comment_at"
    t.integer  "friendship_status",                        :default => 0, :null => false
    t.integer  "votes_value",                              :default => 0, :null => false
    t.datetime "last_viewed_at"
    t.integer  "last_viewed_entries_count",                :default => 0, :null => false
    t.string   "title",                     :limit => 128
  end

  add_index "relationships", ["reader_id", "friendship_status"], :name => "index_relationships_on_reader_id_and_friendship_status"
  add_index "relationships", ["reader_id", "user_id", "position"], :name => "index_relationships_on_reader_id_and_user_id_and_position"
  add_index "relationships", ["reader_id", "votes_value"], :name => "index_relationships_on_reader_id_and_votes_value"
  add_index "relationships", ["user_id", "reader_id", "position"], :name => "index_relationships_on_user_id_and_reader_id_and_position"
  add_index "relationships", ["user_id", "reader_id"], :name => "index_relationships_on_user_id_and_reader_id", :unique => true

  create_table "reports", :force => true do |t|
    t.integer  "reporter_id",      :null => false
    t.integer  "content_id",       :null => false
    t.string   "content_type",     :null => false
    t.integer  "content_owner_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reports", ["content_id", "content_type"], :name => "index_reports_on_content_id_and_content_type"
  add_index "reports", ["content_owner_id"], :name => "index_reports_on_content_owner_id"
  add_index "reports", ["reporter_id", "content_id", "content_type"], :name => "index_reports_on_reporter_id_and_content_id_and_content_type", :unique => true
  add_index "reports", ["reporter_id"], :name => "index_reports_on_reporter_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "sidebar_elements", :force => true do |t|
    t.integer "sidebar_section_id",               :null => false
    t.string  "type",               :limit => 25, :null => false
    t.text    "content",                          :null => false
    t.integer "position"
  end

  create_table "sidebar_sections", :force => true do |t|
    t.integer "user_id",                     :null => false
    t.string  "name",                        :null => false
    t.integer "position"
    t.boolean "is_open",  :default => false, :null => false
  end

  add_index "sidebar_sections", ["user_id", "position"], :name => "index_sidebar_sections_on_user_id_and_position"

  create_table "social_ads", :force => true do |t|
    t.integer  "user_id",                        :null => false
    t.integer  "entry_id",                       :null => false
    t.string   "annotation",                     :null => false
    t.datetime "created_at",                     :null => false
    t.integer  "impressions", :default => 0,     :null => false
    t.integer  "clicks",      :default => 0,     :null => false
    t.boolean  "is_disabled", :default => false, :null => false
  end

  add_index "social_ads", ["created_at", "user_id"], :name => "index_social_ads_on_created_at_and_user_id"
  add_index "social_ads", ["user_id", "entry_id"], :name => "index_social_ads_on_user_id_and_entry_id", :unique => true

  create_table "sphinx_counter", :id => false, :force => true do |t|
    t.integer "counter_id"
    t.integer "max_doc_id"
  end

  add_index "sphinx_counter", ["counter_id"], :name => "index_sphinx_counter_on_counter_id", :unique => true

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "tag_id"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_tag_id", :unique => true

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "tlog_backgrounds", :force => true do |t|
    t.integer "tlog_design_settings_id"
    t.string  "content_type"
    t.string  "filename"
    t.integer "size"
    t.integer "parent_id"
    t.string  "thumbnail"
    t.integer "width"
    t.integer "height"
    t.integer "db_file_id"
  end

  add_index "tlog_backgrounds", ["tlog_design_settings_id"], :name => "index_tlog_backgrounds_on_tlog_design_settings_id"

  create_table "tlog_design_settings", :force => true do |t|
    t.integer  "user_id"
    t.string   "theme"
    t.string   "background_url"
    t.string   "date_style"
    t.text     "user_css"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "color_bg",                        :limit => 6
    t.string   "color_tlog_text",                 :limit => 6
    t.string   "color_tlog_bg",                   :limit => 6
    t.string   "color_sidebar_text",              :limit => 6
    t.string   "color_sidebar_bg",                :limit => 6
    t.string   "color_link",                      :limit => 6
    t.string   "color_highlight",                 :limit => 6
    t.string   "color_date",                      :limit => 6
    t.string   "color_voter_bg",                  :limit => 6
    t.string   "color_voter_text",                :limit => 6
    t.boolean  "background_fixed",                             :default => false, :null => false
    t.boolean  "color_tlog_bg_is_transparent",                 :default => false, :null => false
    t.boolean  "color_sidebar_bg_is_transparent",              :default => false, :null => false
    t.boolean  "color_voter_bg_is_transparent",                :default => false, :null => false
    t.boolean  "large_userpic",                                :default => false, :null => false
  end

  add_index "tlog_design_settings", ["user_id"], :name => "index_tlog_design_settings_on_user_id", :unique => true

  create_table "tlog_settings", :force => true do |t|
    t.integer  "user_id",                                                          :null => false
    t.string   "title"
    t.text     "about"
    t.datetime "updated_at"
    t.string   "rss_link"
    t.boolean  "tasty_newsletter",                     :default => true,           :null => false
    t.string   "default_visibility",                   :default => "mainpageable", :null => false
    t.boolean  "comments_enabled",                     :default => false
    t.integer  "css_revision",                         :default => 1,              :null => false
    t.boolean  "sidebar_is_open",                      :default => true,           :null => false
    t.boolean  "is_daylog",                            :default => false,          :null => false
    t.boolean  "sidebar_hide_tags",                    :default => true,           :null => false
    t.boolean  "sidebar_hide_calendar",                :default => false,          :null => false
    t.boolean  "sidebar_hide_search",                  :default => false,          :null => false
    t.boolean  "sidebar_hide_messages",                :default => false,          :null => false
    t.string   "sidebar_messages_title"
    t.boolean  "email_messages",                       :default => true,           :null => false
    t.boolean  "past_disabled",                        :default => false,          :null => false
    t.string   "privacy",                :limit => 16, :default => "open",         :null => false
    t.integer  "background_id"
  end

  add_index "tlog_settings", ["user_id"], :name => "index_tlog_settings_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.boolean  "is_confirmed",                          :default => false, :null => false
    t.string   "openid"
    t.string   "url",                                                      :null => false
    t.text     "settings"
    t.boolean  "is_disabled",                           :default => false, :null => false
    t.datetime "created_at",                                               :null => false
    t.integer  "entries_count",                         :default => 0,     :null => false
    t.datetime "updated_at"
    t.boolean  "is_mainpageable",                       :default => false, :null => false
    t.string   "domain"
    t.integer  "private_entries_count",                 :default => 0,     :null => false
    t.boolean  "email_comments",                        :default => true,  :null => false
    t.boolean  "comments_auto_subscribe",               :default => true,  :null => false
    t.string   "gender",                  :limit => 1,  :default => "m",   :null => false
    t.string   "username"
    t.string   "salt",                    :limit => 40
    t.string   "crypted_password",        :limit => 40
    t.integer  "faves_count",                           :default => 0,     :null => false
    t.datetime "entries_updated_at"
    t.integer  "conversations_count",                   :default => 0,     :null => false
    t.datetime "disabled_at"
    t.datetime "ban_ac_till"
    t.string   "userpic_file_name"
    t.datetime "userpic_updated_at"
    t.text     "userpic_meta"
    t.datetime "premium_till"
    t.integer  "invitations_left",                      :default => 0,     :null => false
    t.datetime "ban_c_till"
    t.integer  "vk_id"
    t.datetime "last_login_at"
  end

  add_index "users", ["domain"], :name => "index_users_on_domain"
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["openid"], :name => "index_users_on_openid"
  add_index "users", ["url"], :name => "index_users_on_url"
  add_index "users", ["vk_id"], :name => "index_users_on_vk_id"

end
