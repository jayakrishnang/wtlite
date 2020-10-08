class CreateStories < ActiveRecord::Migration[5.2]
  def change
    create_table :stories do |t|
      t.integer :uid
      t.string :title
      t.decimal :total_time, default: 0.0
      t.string :url

      t.timestamps
    end
  end
end
