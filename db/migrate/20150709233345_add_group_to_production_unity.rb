class AddGroupToProductionUnity < ActiveRecord::Migration
  def change
    add_reference :production_unities, :group, index: true, foreign_key: true
  end
end
