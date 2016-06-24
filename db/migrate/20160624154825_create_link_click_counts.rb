class CreateLinkClickCounts < ActiveRecord::Migration
  def change
    create_table :link_click_counts do |t|
      t.references :link, :index => true, :foreign_key => true
      t.date :date
      t.string :agg_type
      t.string :name
      t.integer :count

      t.timestamps :null => false
    end

    add_index :link_click_counts, [:date, :agg_type, :name], :unique => true

  end
end
