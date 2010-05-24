class Asset < ActiveRecord::Base
belongs_to :group
  has_attached_file :asset, :url => "/:class/:attachment/:id/:style_:basename.:extension"

  #has_attached_file :photo

end
