class CreateResponses < ActiveRecord::Migration[5.1]
  def change
    create_table :responses do |t|
      t.string :username
      t.text :body
      t.references :post, foreign_key: true

      t.timestamps
    end
  end
end