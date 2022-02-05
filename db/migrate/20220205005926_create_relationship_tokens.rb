class CreateRelationshipTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :relationship_tokens do |t|

      t.timestamps
    end
  end
end
