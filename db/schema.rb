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

ActiveRecord::Schema.define(:version => 20100503095133) do

  create_table "active_poll_answers", :force => true do |t|
    t.string  "description"
    t.integer "active_poll_question_id"
    t.integer "votes",                   :default => 0
  end

  create_table "active_poll_questions", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "multiple"
    t.integer  "max_multiple"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "target"
  end

  create_table "active_poll_user_answers", :force => true do |t|
    t.integer "user_id"
    t.integer "active_poll_answer_id"
  end

  create_table "activities", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "public",     :default => true
    t.integer  "item_id"
    t.string   "item_type"
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "announcements", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assets", :force => true do |t|
    t.integer  "group_id"
    t.string   "asset_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attendances", :force => true do |t|
    t.integer  "attendee_id"
    t.integer  "event_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blog_mirrors", :force => true do |t|
    t.string   "url"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blog_posts", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "body"
    t.integer  "parent_id"
    t.boolean  "published"
    t.boolean  "featured"
    t.text     "summary"
    t.string   "url"
    t.datetime "published_at"
    t.string   "guid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "views",        :default => 0
  end

  create_table "book_reviews", :force => true do |t|
    t.string   "name"
    t.string   "release_date"
    t.string   "publisher"
    t.string   "website"
    t.string   "buy_link"
    t.text     "review"
    t.integer  "user_id"
    t.string   "image_url"
    t.boolean  "featured",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bug_reports", :force => true do |t|
    t.string   "title"
    t.string   "browser"
    t.integer  "user_id"
    t.text     "description"
    t.string   "module"
    t.boolean  "resolved",        :default => false
    t.text     "comment"
    t.date     "resolution_date"
    t.string   "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "classified_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "classifieds", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "user_id"
    t.integer  "classified_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.string   "comment",                        :default => ""
    t.integer  "commentable_id",                 :default => 0,  :null => false
    t.string   "commentable_type", :limit => 15, :default => "", :null => false
    t.integer  "user_id",                        :default => 0,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["user_id"], :name => "fk_comments_user"

  create_table "content_pages", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "data_files", :force => true do |t|
    t.string   "filename"
    t.string   "content_type"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.datetime "created_at"
    t.integer  "group_id"
    t.datetime "updated_at"
  end

  create_table "domain_themes", :force => true do |t|
    t.string "uri"
    t.string "name"
  end

  add_index "domain_themes", ["uri"], :name => "index_domain_themes_on_uri"

  create_table "facebook_posts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feeds", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "folders", :force => true do |t|
    t.string   "name"
    t.datetime "date_modified"
    t.integer  "user_id",       :default => 0
    t.integer  "parent_id",     :default => 0
    t.boolean  "is_root",       :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "folders", ["date_modified"], :name => "index_folders_on_date_modified"
  add_index "folders", ["is_root"], :name => "index_folders_on_is_root"
  add_index "folders", ["name"], :name => "index_folders_on_name"
  add_index "folders", ["parent_id"], :name => "index_folders_on_parent_id"
  add_index "folders", ["user_id"], :name => "index_folders_on_user_id"

  create_table "follows", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forum_posts", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "body"
    t.integer  "parent_id"
    t.integer  "forum_topic_id"
    t.boolean  "featured"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "views",          :default => 0
  end

  create_table "forum_topics", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "photo_id"
    t.integer  "creator_id"
    t.boolean  "featured"
    t.text     "announcements"
    t.boolean  "private",       :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "html_contents", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ideas", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invites", :force => true do |t|
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "message"
    t.string   "invite_code"
    t.boolean  "accepted"
  end

  create_table "job_posts", :force => true do |t|
    t.string   "job_title"
    t.string   "job_id"
    t.string   "company"
    t.string   "website"
    t.string   "contact_name"
    t.string   "email"
    t.text     "description"
    t.boolean  "featured"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "layouts", :force => true do |t|
    t.integer  "page_id"
    t.integer  "widget_id"
    t.integer  "col_num"
    t.integer  "row_num"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.string   "subject"
    t.text     "body"
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.boolean  "read",         :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "myfile_tags", :force => true do |t|
    t.integer  "myfile_id"
    t.text     "name"
    t.integer  "parent_id",  :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "myfiles", :force => true do |t|
    t.string   "filename"
    t.string   "description",   :default => ""
    t.integer  "filesize"
    t.datetime "date_modified"
    t.integer  "folder_id",     :default => 0
    t.integer  "user_id",       :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "myfiles", ["date_modified"], :name => "index_myfiles_on_date_modified"
  add_index "myfiles", ["filename"], :name => "index_myfiles_on_filename"
  add_index "myfiles", ["filesize"], :name => "index_myfiles_on_filesize"
  add_index "myfiles", ["folder_id"], :name => "index_myfiles_on_folder_id"
  add_index "myfiles", ["user_id"], :name => "index_myfiles_on_user_id"

  create_table "networks", :force => true do |t|
    t.string   "name"
    t.string   "organization"
    t.string   "website"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "permalink"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photo_albums", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "view_count"
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
  end

  create_table "photos", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.integer  "event_id"
    t.string   "title"
    t.text     "description"
    t.string   "location"
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.boolean  "is_profile"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "views",          :default => 0
    t.integer  "view_count"
    t.integer  "photo_album_id"
  end

  create_table "profiles", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.integer  "user_id"
    t.string   "url"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "replies", :force => true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "rolename"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rss_feeds", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "user_id"
    t.boolean  "is_blog"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id",       :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "last_url_visited"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "states", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "status_posts", :force => true do |t|
    t.integer  "user_id"
    t.string   "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tabs", :force => true do |t|
    t.string   "name"
    t.boolean  "enable",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tabs_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "tab_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "themes", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login"
    t.string   "email"
    t.string   "email_hash"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "sex"
    t.string   "city"
    t.integer  "state_id"
    t.string   "zip"
    t.integer  "country_id"
    t.string   "phone"
    t.string   "phone2"
    t.string   "time_zone",                               :default => "UTC"
    t.text     "about_me"
    t.string   "organization"
    t.text     "skills"
    t.text     "occupation"
    t.boolean  "featured",                                :default => false
    t.boolean  "show_blog_posts_on_home",                 :default => true
    t.boolean  "use_gravatar",                            :default => false
    t.string   "website"
    t.string   "blog"
    t.string   "blog_feed"
    t.string   "flickr"
    t.string   "flickr_username"
    t.string   "linked_in_url"
    t.string   "twitter_id"
    t.boolean  "display_tweets",                          :default => false
    t.string   "aim_name"
    t.string   "gtalk_name"
    t.string   "yahoo_messenger_name"
    t.string   "msn_name"
    t.string   "youtube_username"
    t.string   "skype_name"
    t.string   "facebook_url"
    t.integer  "facebook_id"
    t.string   "resume_url"
    t.string   "company_url"
    t.integer  "posts_count",                             :default => 0
    t.datetime "last_seen_at"
    t.integer  "login_count",                             :default => 0
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "password_reset_code",       :limit => 40
    t.boolean  "enabled",                                 :default => true
    t.boolean  "is_active",                               :default => false
    t.string   "identity_url"
    t.boolean  "receive_emails",                          :default => true
    t.string   "api_key",                   :limit => 40, :default => ""
  end

  create_table "videos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wall_posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.integer  "event_id"
    t.integer  "sender_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "widget_layouts", :force => true do |t|
    t.integer  "page_id"
    t.integer  "widget_id"
    t.integer  "col_num"
    t.integer  "row_num"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "widgets", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.boolean  "active"
    t.boolean  "protected"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "html_content_id"
  end

  create_table "wiki_page_versions", :force => true do |t|
    t.integer  "page_id",    :null => false
    t.integer  "updator_id"
    t.integer  "number"
    t.string   "comment"
    t.string   "path"
    t.string   "title"
    t.text     "content"
    t.datetime "updated_at"
  end

  add_index "wiki_page_versions", ["page_id"], :name => "index_wiki_page_versions_on_page_id"
  add_index "wiki_page_versions", ["updator_id"], :name => "index_wiki_page_versions_on_updator_id"

  create_table "wiki_pages", :force => true do |t|
    t.integer  "creator_id"
    t.integer  "updator_id"
    t.string   "path"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wiki_pages", ["creator_id"], :name => "index_wiki_pages_on_creator_id"
  add_index "wiki_pages", ["path"], :name => "index_wiki_pages_on_path", :unique => true

end
