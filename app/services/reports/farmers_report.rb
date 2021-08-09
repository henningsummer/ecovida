module Reports
  class FarmersReport < FilterReportService
    def initialize
      super(Farmer)
    end

    def filter(params)
      params = params.deep_symbolize_keys

      objects = super

      objects = filter_by_certificate(objects, params)
      objects = filter_by_all_documents(objects, params)

      klass.where(id: objects.map(&:id))
    end

    def object_inicialization
      klass.joins(city: [:state], group: [:core])
    end

    def object_table_name
      'farmers'
    end

    def filter_by_certificate(objects, params)
      return objects if params[:has_certificate].nil?

      objects = objects.select do |farmer|
        have_certificate = farmer.certificate_names.any?
        valid_certificate = have_certificate && farmer.certificate_names.last.certificate.certificate_group.meeting_date + 1.year > Time.now

        valid_certificate.to_s == params[:has_certificate]
      end

      objects
    end

    def filter_by_all_documents(objects, params)
      return objects if params[:all_documents].nil?

      objects = objects.select { |farmer| farmer.can_have_certificate?.to_s == params[:all_documents] }

      objects
    end
  end
end
