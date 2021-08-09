class AddIsProcessorToScopeProduct < ActiveRecord::Migration
  def change
    add_column :scope_products, :is_processor, :boolean
  end
end
