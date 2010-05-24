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

class Link < ActiveRecord::Base
  
  include Streamable 
  acts_as_streamable
  
  belongs_to :user
  
  
  validates_presence_of  :title, :url
  validates_length_of :title, :maximum=>200

end
