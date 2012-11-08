# This migration comes from paperclip_atompub (originally 20121108051952)
class CreatePaperclipAtompubAttachments < ActiveRecord::Migration
  def change
    create_table :paperclip_atompub_attachments do |t|
      t.string :instance_type, :null => false
      t.integer :instance_id, :null => false
      t.string :attachment_name, :null => false
      t.string :style, :null => false
      t.string :resource_uri, :null => false
      t.string :content_src, :null => false
      t.timestamps
    end
    add_index :paperclip_atompub_attachments, [:instance_type, :instance_id], :name => 'attachments_on_instance_type_and_instance_id'
    add_index :paperclip_atompub_attachments, [:instance_type, :instance_id, :attachment_name], :name => 'instance_type_and_instance_id_and_attachment_name'
    add_index :paperclip_atompub_attachments, [:instance_type, :instance_id, :attachment_name, :style], :unique => true, :name => 'instance_type_and_instance_id_and_attachment_name_and_style'
  end
end
