class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :external_id
      t.string :platform
      t.integer :menu_level, default: 0

      t.timestamps
    end
  end
end
