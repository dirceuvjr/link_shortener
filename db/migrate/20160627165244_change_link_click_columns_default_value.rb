class ChangeLinkClickColumnsDefaultValue < ActiveRecord::Migration
  def change

    change_column :link_clicks, :device, :string, :default => 'Unknown'
    change_column :link_clicks, :platform, :string, :default => 'Unknown'
    change_column :link_clicks, :platform_version, :string, :default => 'Unknown'
    change_column :link_clicks, :operating_system, :string, :default => 'Unknown'
    change_column :link_clicks, :operating_system_version, :string, :default => 'Unknown'
    change_column :link_clicks, :engine, :string, :default => 'Unknown'
    change_column :link_clicks, :engine_version, :string, :default => 'Unknown'
    change_column :link_clicks, :browser, :string, :default => 'Unknown'
    change_column :link_clicks, :browser_version, :string, :default => 'Unknown'

  end
end
