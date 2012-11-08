module PaperclipAtompub
  class Attachment < ActiveRecord::Base
    attr_accessible :attachment_name, :instance_id, :instance_type, :resource_uri, :style
    belongs_to :instance, :polymorphic => true
  end
end
