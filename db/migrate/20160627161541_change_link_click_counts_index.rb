class ChangeLinkClickCountsIndex < ActiveRecord::Migration

  def change

    remove_index :link_click_counts, [:date, :agg_type, :name]

    add_index :link_click_counts, [:link_id, :date, :agg_type, :name], :unique => true, :name => 'link_click_counts_unique'

  end

end
