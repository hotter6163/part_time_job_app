class AddColumnsToLineLink < ActiveRecord::Migration[6.1]
  def change
    add_column :line_links, :delete_digest, :string
    add_column :line_links, :delete_sent_at, :datetime
  end
end
