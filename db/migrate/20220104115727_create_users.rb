class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.boolean :admin
      t.boolean :master
      t.boolean :activated
      t.datetime :activated_at
      t.string :activation_digest

      t.timestamps
    end
  end
end
