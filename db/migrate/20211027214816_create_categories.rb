class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.integer :user_id
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
