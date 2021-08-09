class GroupService
  def initialize(group)
    @group = group
  end

  def change_to_core(core)
    ActiveRecord::Base.transaction(joinable: false, requires_new: true) do
      return false if core.state.id != @group.core.state.id

      @group.update(core: core)

      uf = core.state.uf.to_s

      @group.farmers.find_each do |farmer|
        new_code = generate_code(uf, @group.core.next_farmer_count + 1, @group.core.number_from_state)
        farmer.update(farmer_code: new_code)
        @group.core.update(next_farmer_count: @group.core.next_farmer_count + 1)
      end

      true
    end
  end

  def destroy
    @group.production_unities.each do |production_unity|
      production_unity.update(excluded_with_group: true)

      ProductionUnityService.destroy(production_unity)
    end

    @group.farmers.each do |farmer|
      farmer.update(excluded_with_group: true)

      FarmerService.destroy(farmer)
    end

    @group.update(excluded: true)

    @group
  end

  private

  def generate_code(state, farmer_id, core_id)
    code = state.dup

    if core_id < 10
      code << '0'
      code << core_id.to_s
    else
      code << core_id.to_s
    end

    if farmer_id < 10
      code << '00'
      code << farmer_id.to_s
    elsif farmer_id >= 10 and farmer_id < 100
      code << '0'
      code << farmer_id.to_s
    else
      code << farmer_id.to_s
    end

    return code

  end
end
