class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :name      

      t.timestamps
    end
    add_attachment :users, :avatar
  end

  def down
    remove_attachment :users, :avatar
    drop_table :users
  end
end
