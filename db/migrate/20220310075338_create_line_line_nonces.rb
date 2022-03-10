class CreateLineLineNonces < ActiveRecord::Migration[6.1]
  def change
    create_table :line_line_nonces do |t|
      t.string :nonce
      t.integer :user_id
      t.boolean :validity, default: true

      t.timestamps
    end
    add_index :line_line_nonces, :nonce
  end
end
