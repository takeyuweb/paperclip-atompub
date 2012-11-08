class User < ActiveRecord::Base
  attr_accessible :name, :avatar
  has_attached_file :avatar,
  :storage => :atompub,
  :atompub_config => Settings.atompub_config,
  :atompub_credentials => File.join(Rails.root, 'config/atompub.yml'),
  # :atompub_credentials => lambda{|attachment|
  #   user = attachment.instance
  #   { :username => user.atompub_username, :password => user.atompub_password }
  # },
  :styles => { :medium => "300x300>", :thumb => "100x100>" }
end
