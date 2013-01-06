class CreateEmptyBoxes < ActiveRecord::Migration
  def change
    create_table :empty_boxes do |t|
      t.string :state

      t.timestamps
    end
  end
end
