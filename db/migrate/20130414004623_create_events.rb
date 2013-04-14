class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :event_name
      t.string :file
      t.integer :line
      t.string :classname
      t.string :id

      t.timestamps
    end
  end
end
