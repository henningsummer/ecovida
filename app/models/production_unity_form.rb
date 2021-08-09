class ProductionUnityForm


    SCOPE_TYPES = ['Orgânico', 'Biodinâmico', 'Em transição']
    attr_accessor :production_unity_to_read
    include ActiveModel::Model
    attr_accessor :cep, :fantasy_name, :name, :cnpj, :register_type, :register_number,
    :address, :neighborhood, :city_id, :group_id, :farmer_id, :scope_type,
    :total_area, :total_organic_area, :total_native_area, :phone, :email, :production_type, :scopes, :number_type, :number,
    :lat_hour, :lat_minute, :lat_second, :lon_hour, :lon_minute, :lon_second, :lat_type, :lon_type

    # Usar apenas em produção
    # validate :validate_cnpj
    validates_format_of :cep, with: /[0-9]{8}/, message: "Use apenas números. Exemplo: 95560000"
    validates_presence_of :cep, :name, :address, :neighborhood, :city_id, :group_id, :farmer_id, :scope_type
    validates_presence_of :number, :number_type, :if => :is_agribusiness?
    validates_presence_of :total_area, :total_organic_area, if: :is_production_unity? # Cancelado #i
    validate :validate_number, :if => :is_agribusiness? #Valida CPF ou CNPJ
    validates_inclusion_of :production_type, :in => SCOPE_TYPES
    validates_inclusion_of :scope_type, :in => ["1" , "2"]
    validates_inclusion_of :number_type, :in => ["1", "2"], :if => :is_agribusiness?
    validates :lat_hour, :lat_minute, :lat_second, :lat_type, presence: true, if: :is_production_unity?
    validates :lon_hour, :lon_minute, :lon_second, :lon_type, presence: true, if: :is_production_unity?
    validates_numericality_of :lat_hour, greater_than_or_equal_to: 0, less_than_or_equal_to: 90, if: :is_production_unity?
    validates_numericality_of :lon_hour, greater_than_or_equal_to: 0, less_than_or_equal_to: 180, if: :is_production_unity?
    validates_numericality_of :lat_second, :lon_second, greater_than_or_equal_to: 0, less_than_or_equal_to: 60.99, if: :is_production_unity?
    validates_numericality_of :lon_minute, :lat_minute, greater_than_or_equal_to: 0, less_than_or_equal_to: 60, if: :is_production_unity?
    validates_inclusion_of :lon_type, :in => ["L", "O"], :if => :is_production_unity?
    validates_inclusion_of :lat_type, :in => ["N", "S"], :if => :is_production_unity?

    validates_numericality_of :total_area, :total_organic_area, :if => :is_production_unity?


    def validate_number
      require 'cpf_cnpj'

      if self.number_type == "1"
        errors.add(:number, 'CPF é inválido') unless CPF.valid? self.number
      else
        errors.add(:number, 'CNPJ é inválido') unless CNPJ.valid? self.number
      end
    end

    def self.SCOPE_TYPES
      SCOPE_TYPES
    end

    def is_production_unity?
      scope_type == "1"
    end

    def is_agribusiness?
      scope_type == "2"
    end

    def save!
      if self.valid?
        farmer = Farmer.where(group_id: self.group_id).find_by(id: self.farmer_id)
        if not farmer.nil?
          if production_unity = ProductionUnity.create(cep: self.cep, name: self.name, fantasy_name: self.fantasy_name,
                                                    number: self.number, number_type: self.number_type, address: self.address, neighborhood: self.neighborhood,
                                                    city_id: self.city_id, group_id: self.group_id, scope_type: self.scope_type,
                                                    total_area: self.total_area,
                                                    total_organic_area: self.total_organic_area, total_native_area: self.total_native_area,
                                                    phone: self.phone, email: self.email, production_type: self.production_type,
                                                    register_type: self.register_type, register_number: self.register_number, lat_hour: self.lat_hour, lat_minute: self.lat_minute,
                                                    lat_second: self.lat_second, lat_type: self.lat_type, lon_hour: self.lon_hour, lon_minute: self.lon_minute,
                                                    lon_second: self.lon_second, lon_type: self.lon_type)

          production_unity_farmer = ProductionUnityFarmer.create(production_unity: production_unity,
                                                                 farmer_id: farmer.id,
                                                                 is_responsible: true)


          #Criamos os escopos
          if not scopes.nil?
            self.scopes.each do |scope_id, value|
              ProductionUnityScope.create(scope_id: scope_id, production_unity_id: production_unity.id)
            end
          end
          self.production_unity_to_read = production_unity
          end
          true
        else
          errors.add(:name, "Impossível cadastrar esse agricultor")
          nil
        end
      else
        nil
      end
    end

    private

    def validate_cnpj
      require 'cpf_cnpj'
      errors.add(:cnpj, "CNPJ Inválido") unless CNPJ.valid? self.cnpj
    end


end
