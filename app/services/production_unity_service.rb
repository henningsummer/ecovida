class ProductionUnityService
  def self.destroy(production_unity)
    production_unity.update(excluded: true)

    production_unity
  end
end
