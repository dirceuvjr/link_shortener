class AddCountryToLinkClick < ActiveRecord::Migration
  def change
    add_column :link_clicks, :country, :string

    add_index :link_clicks, :country
  end
end
