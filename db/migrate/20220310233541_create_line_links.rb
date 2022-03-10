class CreateLineLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :line_links do |t|
      t.references :user, foreign_key: true
      t.string :line_id

      t.timestamps
    end
    add_index :line_links, :line_id
  end
end
