
class ReferenceDataset < ActiveRecord::Base
  belongs_to :medsa_content,
    :foreign_key => "legume_id"

  scope :public_reference_datasets, where({ :is_public => 1 }).order("reference_dataset_type ASC")

  validates_format_of :url, :with => URI::regexp(%w(http https ftp)),
    :allow_blank => true, :message => ' is not valid. Please include a valid protocol.'
  validates_presence_of :is_public,
    :message => ' is not set. Please select Yes or No.'
end
