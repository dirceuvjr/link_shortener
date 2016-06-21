class CreateLinkClicks < ActiveRecord::Migration
  def change
    create_table :link_clicks do |t|
      t.references :link, :index => true, :foreign_key => true

      t.string :ip

      t.decimal :lat, :precision => 15, :scale => 10
      t.decimal :lng, :precision => 15, :scale => 10

      t.string :device

      t.string :platform
      t.string :platform_version

      t.string :operating_system
      t.string :operating_system_version

      t.string :engine
      t.string :engine_version

      t.string :browser
      t.string :browser_version

      t.timestamps :null => false
    end

    add_index :link_clicks, :device
    add_index :link_clicks, :platform
    add_index :link_clicks, :operating_system
    add_index :link_clicks, :engine
    add_index :link_clicks, :browser

    add_index :link_clicks, [:lat, :lng]
  end
end
