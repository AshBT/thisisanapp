class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :source
      t.string :target

      t.timestamps
    end
  end
end
