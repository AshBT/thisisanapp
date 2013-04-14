class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :source
      t.string :target

      t.timestamps
    end
  end
end
