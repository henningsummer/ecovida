class AddCurrentToCoreCoordinators < ActiveRecord::Migration
  def change
    add_column :core_coordinators, :current, :bool

    Core.all.each do |core|
      coordinators = core.core_coordinators

      coordinators.order(created_at: :desc)&.first&.update(current: true)
    end
  end
end
