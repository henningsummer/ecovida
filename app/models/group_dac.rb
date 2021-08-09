class GroupDac
  include ActiveModel::Model
  attr_accessor :data_dac, :group, :farmers, :author

  def save!
    farmers_on_group = @group.farmers.map(&:id)
    if @farmers.present?
    @farmers.each do |farmer|
      errors.add(:base, "Impossível adicionar dacs para agricultor de ID #{farmer[0]}") if not farmers_on_group.include? farmer[0].to_i
    end
    end

    if self.errors.count == 0
      data_dac = Date.new(@data_dac["data_dac(1i)"].to_i,@data_dac["data_dac(2i)"].to_i, @data_dac["data_dac(3i)"].to_i )
      if @farmers.present?
        @farmers.each do |farmer|
          farmer_object = Farmer.find(farmer[0].to_i)
          if farmer[1]["cadastrar"]
            Dac.create(dac_date: data_dac, sampling: farmer[1]["amostragem"], farmer_id: farmer[0].to_i)
            SystemLog.create(description: "Cadastrou uma nova D.A.C para #{farmer_object.name} (#{farmer_object.farmer_code}) - #{farmer[1]["amostragem"] ? "Por amostragem" : "Não foi por amostragem"} - (Via função de cadastrar D.A.C para grupo inteiro)", author: self.author)
          end
          
          farmer_object.update(contract_of_adhesion: farmer[1]['contract_of_adhesion'].present? ? true : false)
          SystemLog.create(description: "Foram atualizadas as informações básicas do agricultor #{farmer_object.name} (#{farmer_object.farmer_code}) (Via função de cadastrar D.A.C para grupo inteiro)", author: author) unless farmer_object.previous_changes.empty?
        end
      end
      true
    else
      false
    end
  end

end
