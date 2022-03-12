class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.integer :category_id
      t.integer :user_id
      t.integer :status, default: 0
      t.datetime :deadline
      t.boolean :completed, default: false
      t.timestamps
    end
  end
end
