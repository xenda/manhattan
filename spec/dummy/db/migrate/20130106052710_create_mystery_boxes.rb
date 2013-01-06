class CreateMysteryBoxes < ActiveRecord::Migration
  def change
    create_table :mystery_boxes do |t|
      t.string :status

      t.timestamps
    end
  end
end
