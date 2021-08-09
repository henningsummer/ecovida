class DropAcronym < ActiveRecord::Migration
  def up
    drop_table :acronyms
  end
  def down
    raise ActiveRecord::IrreversibleMigration, "Não é possível restaurar o acronym"
  end
end
