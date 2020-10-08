class CreateTrackerFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :tracker_files do |t|
      t.string :filename

      t.timestamps
    end
  end
end
