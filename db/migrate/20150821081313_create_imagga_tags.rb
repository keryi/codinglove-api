class CreateImaggaTags < ActiveRecord::Migration
  def change
    create_table :imagga_tags do |t|
      t.string :confidence
      t.string :name
      t.references :post, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
