class CreateLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :logs do |t|
      t.references :story, foreign_key: true
      t.date :log_date
      t.decimal :time, default: 0.0

      t.timestamps
    end
  end
end
