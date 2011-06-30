
class Resource < ActiveRecord::Base
  belongs_to :lencu_content, 
    :foreign_key => "legume_id"
  
  scope :public_resources, where({:is_public => 1}).order("resource_type ASC")
  
  validates_format_of :url, :with => URI::regexp(%w(http https ftp)),
    :allow_blank => true, :message => ' is not valid. Please include a valid protocol.'
end
