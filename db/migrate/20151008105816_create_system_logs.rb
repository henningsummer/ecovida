class CreateSystemLogs < ActiveRecord::Migration
  def change
    create_table :system_logs do |t|
      t.string :description
      t.string :author
      
      t.timestamps null: false
    end
  end
end
