class CreateGroupTypes < ActiveRecord::Migration
  def change
    create_table :group_types do |t|
      t.string :description

      t.timestamps null: false
    end
  end
end
