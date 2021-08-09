class FilterReportService
  def initialize(klass)
    @klass = klass
  end

  attr_accessor :klass

  def filter(params)
    params = params.deep_symbolize_keys
    objects = object_inicialization

    objects = filter_by_city(objects, params)
    objects = filter_by_name(objects, params)
    objects = filter_by_core(objects, params)
    objects = filter_by_group(objects, params)
    objects = filter_by_date_gte(objects, params)
    objects = filter_by_date_lte(objects, params)
    objects = filter_by_state(objects, params)

    objects
  end

  private

  def object_inicialization
    raise "Implement object_inicialization on your service"
  end

  def object_table_name
    raise "Implement object_table_name on your service"
  end

  def filter_by_date_gte(objects, params)
    return objects unless objects.any? && params[:created_at_gte].present?

    objects = objects.where(["#{object_table_name}.created_at >= :created_at_gte", created_at_gte: Time.parse(params[:created_at_gte])])

    objects
  end

  def filter_by_date_lte(objects, params)
    return objects unless objects.any? && params[:created_at_lte].present?

    objects = objects.where(["#{object_table_name}.created_at <= :created_at_lte", created_at_lte: Time.parse(params[:created_at_lte])])

    objects
  end

    def filter_by_state(objects, params)
      return objects unless objects.any? && params[:state_id].present?

      objects = objects.where("cities.state_id = #{params[:state_id]}")

      objects
    end

  def filter_by_city(objects, params)
    return objects unless objects.any? && params[:city_id].present? && objects.first.respond_to?(:city)

    objects = objects.where(city_id: params[:city_id])

    objects
  end

  def filter_by_name(objects, params)
    return objects unless objects.any? && params[:name].present? && objects.first.respond_to?(:name)

    objects = objects.where(["#{object_table_name}.name ILIKE :name", name: "%#{params[:name]}%"])

    objects
  end

  def filter_by_core(objects, params)
    return objects unless objects.any? && params[:core_id].present?

    objects = objects.where("groups.core_id = #{params[:core_id]}")

    objects
  end

  def filter_by_group(objects, params)
    return objects unless objects.any? && params[:group_id].present? && objects.first.respond_to?(:group)

    objects = objects.where(group_id: params[:group_id])

    objects
  end
end
