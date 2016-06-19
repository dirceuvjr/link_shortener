class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :url
      t.string :slug
      t.references :user, :index => true, :foreign_key => true
      t.datetime :expiration_date
      t.string :title

      t.timestamps :null => false
    end

    add_attachment :links, :snapshot
    add_index :links, :slug, :unique => true

  end
end
