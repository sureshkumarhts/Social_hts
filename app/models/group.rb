#   Copyright 2009 Timothy Fisher
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

# == Schema Information
# Schema version: 20090206190209
#
# Table name: groups
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :text
#  photo_id    :integer(4)
#  creator_id  :integer(4)
#  featured    :boolean(1)
#  created_at  :datetime
#  updated_at  :datetime
#

class Group < ActiveRecord::Base
   has_many :group_permissions
  has_many :memberships, :dependent => :destroy
  has_many :users, :through => :memberships, :order=>'RAND()' 
  
  belongs_to :creator, :class_name => 'User' # the creator
  has_many :forum_topics, :order=>'created_at DESC'
  has_many :events, :order=>'created_at DESC'
  has_many :assets, :order=>'created_at DESC'
  has_one :profile_photo
  has_many :wall_posts, :order=>'created_at DESC'
  has_many :permissions
  has_many :admins, :source=>:user, :through => :permissions
  
   acts_as_ferret :store_class_name => true
  after_create :log_activity

  
  @@cached_groups = nil
  
  def self.cached_groups
    @@cached_groups ||= Group.find(:all, :select=>"id, name", :limit=>6)
  end
  
  
  def self.reset_cache
    @@cached_groups = nil
  end
  
  
  def log_activity
    Activity.create!(:item => self, :user => self.creator)
  end
    
  
end
