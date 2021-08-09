module Reports
  class DynamicProductsReport < FilterReportService
    def initialize
      super(ScopeProduct)
    end

    def filter(params)
      params = params.deep_symbolize_keys

      objects = super

      objects = filter_by_product_id(objects, params)
      objects = filter_by_scope_id(objects, params)

      products_ids = objects.map(&:product_id).uniq
      products = Product.where(id: products_ids)

      count = products.count
      products = products.page(params[:page]).per(15)

      production_unities_hash = {}
      products.map do |product|
        production_unities_hash[product.id] = [] if production_unities_hash[product.id].nil?

        production_unities_hash[product.id] << objects.where(product_id: product.id).map(&:production_unity_scope)
                                                                                    .map(&:production_unity).compact
      end

      { products: products, count: count, production_unities: production_unities_hash }
    end

    def object_inicialization
      klass.joins(production_unity_scope: { production_unity: [city: :state, group: :core] }, product: { product_category: :scope })
    end

    def object_table_name
      'scope_products'
    end

    def filter_by_city(objects, params)
      return objects unless objects.any? && params[:city_id].present?

      objects = objects.where("production_unities.city_id = #{params[:city_id]}")

      objects
    end

    def filter_by_group(objects, params)
      return objects unless objects.any? && params[:group_id].present?

      objects = objects.where("production_unities.group_id = #{params[:group_id]}")

      objects
    end


    def filter_by_product_id(objects, params)
      return objects unless objects.any? && params[:product_id].present?

      objects = objects.where(product_id: params[:product_id].to_i)

      objects
    end

    def filter_by_scope_id(objects, params)
      return objects unless objects.any? && params[:scope_id].present?

      objects = objects.where("product_categories.scope_id = #{params[:scope_id]}")

      objects
    end
  end
end
