module Reports
  class ProductionUnityReport < FilterReportService
    def initialize
      super(ProductionUnity)
    end

    def filter(params)
      params = params.deep_symbolize_keys

      objects = super

      # TODO fazer aqui as queries extras.

      objects
    end
  end
end
