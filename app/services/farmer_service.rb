class FarmerService
  class << self
    def destroy(farmer)
      return false if [farmer.group.suplente, farmer.group.titular].include? farmer

      farmer.production_unity_farmers.each do |production_unity_farmer|
        if production_unity_farmer.production_unity.production_unity_farmers.select { |pf| pf.farmer.excluded == false }.count == 1
          ProductionUnityService.destroy(production_unity_farmer.production_unity)
        else
          change_responsible(farmer, production_unity_farmer) if production_unity_farmer.is_responsible
        end
      end

      farmer.excluded = true
      farmer.save(validate: false)

      farmer
    end

    private

    def change_responsible(farmer, production_unity_farmer)
      production_unity_farmer.update(is_responsible: false)

      new_farmer = production_unity_farmer.production_unity.production_unity_farmers.where.not(id: production_unity_farmer.id)
                                          .first

      new_farmer.is_responsible = true

      new_farmer.save!
    end
  end
end
