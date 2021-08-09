module Reports
  class ProductsReport
    def initialize(groups)
      @groups = groups
      @file_name = Rails.root.join('app', 'reports', 'relatorio_de_produtos.odt')
      @products = OpenStruct.new
    end

    def self.generate_products_to_report(group)
      # Mudar essa função para receber o grupo e fazer o que tiver que fazer.

      scopes = OpenStruct.new

      response = []

      Scope.all.each do |scope|
        response[scope.id] = OpenStruct.new(name: scope.name, products: [])
      end

      group.scope_products.each do |product|
        scope = product.product.product_category.scope.id

        product_name = product.product.name

        if response[scope].products[product.product.id].nil?
          value = OpenStruct.new(product_name: product_name,
                                 cities: [],
                                 farmers: [],
                                 area: 0,
                                 with_area: 0,
                                 without_area: 0,
                                 estimative_volumn: {})
          response[scope].products[product.product.id] = value
          response[scope].products.compact
        end

        response[scope].products[product.product.id].cities << product.production_unity_scope.production_unity.city.name
        product.production_unity_scope.production_unity.farmers.each do |farmer|
          response[scope].products[product.product.id].farmers << "#{farmer.name} #{farmer.farmer_code}"
        end

        if product.amount_value
          response[scope].products[product.product.id].estimative_volumn[product.unity_value.to_sym] ||= 0
          response[scope].products[product.product.id].estimative_volumn[product.unity_value.to_sym] += product.amount_value
        else
          response[scope].products[product.product.id].estimative_volumn[:nao_informado] ||= 0
          response[scope].products[product.product.id].estimative_volumn[:nao_informado] += 1
        end

        if product.area.present?
          response[scope].products[product.product.id].area += product.area
          response[scope].products[product.product.id].with_area += 1
        else
          response[scope].products[product.product.id].without_area += 1
        end

        response[scope].products[product.product.id].farmers.uniq!
        response[scope].products[product.product.id].cities.uniq!
      end

      response.compact!

      response.each do |scope|
        scope.products.compact!

        scope.products.each do |product|
          product.estimative_volumn = self.normalize_volumn(product.estimative_volumn)
        end
      end

      response.select { |scope| scope.products.count > 0 }
    end

    def self.normalize_volumn(estimative_volumn)
      ''.tap do |string|
        estimative_volumn.each do |key, val|
          string << " #{val} #{key}(s) +"
        end

        string[-1] = '.' if string.length > 0
      end
    end

    def self.totals_for(groups)
      products = []

      groups.each do |group|
        group.scope_products.each do |product|

          product_name = product.product.name

          if products[product.product_id].nil?
            products[product.product_id] = OpenStruct.new(product_name: product_name,
                                                          cities: [],
                                                          farmers: [],
                                                          area: 0,
                                                          with_area: 0,
                                                          without_area: 0,
                                                          estimative_volumn: {})
          end

          products[product.product.id].cities << product.production_unity_scope.production_unity.city.name
          product.production_unity_scope.production_unity.farmers.each do |farmer|
            products[product.product.id].farmers << "#{farmer.name} #{farmer.farmer_code}"
          end

          if product.amount_value
            products[product.product.id].estimative_volumn[product.unity_value.to_sym] ||= 0
            products[product.product.id].estimative_volumn[product.unity_value.to_sym] += product.amount_value
          else
            products[product.product.id].estimative_volumn[:nao_informado] ||= 0
            products[product.product.id].estimative_volumn[:nao_informado] += 1
          end

          if product.area.present?
            products[product.product.id].area += product.area
            products[product.product.id].with_area += 1
          else
            products[product.product.id].without_area += 1
          end

          products[product.product.id].farmers.uniq!
          products[product.product.id].cities.uniq!
        end
      end

      products.compact!

      estimatives = products.map(&:estimative_volumn)

      products.each do |product|
        product.estimative_volumn = self.normalize_volumn(product.estimative_volumn)
      end

      {
        each_total: products,
        farmers_count: products.map(&:farmers).flatten.uniq.count,
        cities_count: products.map(&:cities).flatten.uniq.count,
        products_count: products.count,
        total_area: products.sum(&:area).round(2),
        total_with_area: products.sum(&:with_area),
        total_without_area: products.sum(&:without_area),
        total_estimative_volumn: self.normalize_volumn(self.calculate_total_estimative(estimatives))
      }
    end

    def self.calculate_total_estimative(estimatives)
      totals = {}

      estimatives.each do |estimative|
        estimative.each do |key, val|
          totals[key] ||= 0

          totals[key] += val
        end
      end

      totals
    end

    def process(email)
      # generate_products_to_report

      totals = Reports::ProductsReport.totals_for(@groups)

      report = ODFReport::Report.new(@file_name) do |r|
        r.add_field "RELATORY_DATE", I18n.l(Time.zone.now)

        r.add_section("group", @groups) do |g|
          g.add_field("GROUP_NAME", :name)
          g.add_field("CORE_NAME", :core_name)
          g.add_section("scope", :scopes) do |s|
            s.add_field("SCOPE_NAME", :name)
            s.add_table("products", :products) do |p|
              p.add_column("PRODUCT_NAME", :product_name)
              p.add_column("CITIES", :cities)
              p.add_column("FARMERS", :farmers)
              p.add_column("AREA", :area)
              p.add_column("WITH_AREA", :with_area)
              p.add_column("WITHOUT", :without_area)
              p.add_column("ESTIMATIVE_VOLUME", :estimative_volumn)
            end
          end
        end

        r.add_table("product_total", totals[:each_total]) do |p|
          p.add_column("PRODUCT_NAME", :product_name)
          p.add_column("CITIES", :cities)
          p.add_column("FARMERS", :farmers)
          p.add_column("AREA", :area)
          p.add_column("WITH_AREA", :with_area)
          p.add_column("WITHOUT", :without_area)
          p.add_column("ESTIMATIVE_VOLUME", :estimative_volumn)
        end

        r.add_field("PRODUCTS_COUNT", totals[:products_count])
        r.add_field("CITIES_COUNT", totals[:cities_count])
        r.add_field("FARMERS_COUNT", totals[:farmers_count])
        r.add_field("TOTAL_AREA", totals[:total_area])
        r.add_field("TOTAL_WITH_AREA", totals[:total_with_area])
        r.add_field("TOTAL_WITHOUT_AREA", totals[:total_without_area])
        r.add_field("TOTAL_ESTIMATIVE_VOLUMN", totals[:total_estimative_volumn])
      end

      report.generate('tmp/report.odt')

      SendReport.delay.send_report(email, 'Relatório de produtos', 'tmp/report.odt', 'relatorio_de_produtos')
    end

    handle_asynchronously :process
  end
end
