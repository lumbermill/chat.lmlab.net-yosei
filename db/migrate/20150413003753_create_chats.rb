class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.string :user
      t.text :message
      t.datetime :sendtime

      t.timestamps null: false
    end
  end
end
