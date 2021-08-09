# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'net/http'
require 'net/https' # for ruby 1.8.7
require 'json'

module BRPopulate
  def self.states
    http = Net::HTTP.new('raw.githubusercontent.com', 443); http.use_ssl = true
    JSON.parse http.get('/celsodantas/br_populate/master/states.json').body
  end

  def self.capital?(city, state)
    city['name'] == state['capital']
  end

  def self.populate
    states.each do |state|
      state_obj = State.new(uf: state['acronym'], name: state['name'])
      state_obj.save

      state['cities'].each do |city|
        c = City.new
        c.name = city['name']
        c.state = state_obj
        c.save
      end
    end
  end
end

if State.count == 0
  BRPopulate.populate

  Admin.create(name: "Otávio Schwanck dos Santos", login: "otavio", password: "123", password_confirmation: "123")

  # Escopos conhecidos
  Scope.create(name: "Produção primária animal", acronym: "PPA", scope_type: 1)
  Scope.create(name: "Produção primária vegetal", acronym: "PPV", scope_type: 1)
  Scope.create(name: "Processamento de produtos de origem vegetal", acronym: "POV", scope_type: 2)
  Scope.create(name: "Processamento de produtos de origem animal", acronym: "POA", scope_type: 2)
  Scope.create(name: "Extrativismo sustentável orgânico", acronym: "EXT", scope_type: 1)
  Scope.create(name: "Processamento de produtos textéis", acronym: "PPT", scope_type: 2)
  Scope.create(name: "Processamento de insumos agrículas", acronym: "PIA", scope_type: 2)
end

if Rails.env == "development"
  require 'faker'


  5.times do
    new_group_type = GroupType.create(description: Faker::Company.profession)
    new_group_type.save
  end

  185.times do
    new_product_category = ProductCategory.create(name: Faker::Commerce.product_name, scope:  Scope.all.sample )
  end

  300.times do
    new_product = Product.create(name: Faker::Commerce.product_name, product_category:  ProductCategory.all.sample )
    new_product.save
  end

  28.times do
    begin
      FactoryGirl.create(:core, state: State.all.sample)
    rescue => ex

    end
  end

  28.times do
    begin
      FactoryGirl.create(:group, group_type: GroupType.all.sample, core: Core.all.sample)
    rescue => ex

    end
  end

  320.times do
    begin
      group = Group.all.sample
      FactoryGirl.create(:farmer, group: group, city: group.core.state.cities.sample)
    rescue => ex

    end
  end

  400.times do
    begin
      FactoryGirl.create(:dac, farmer: Farmer.all.sample)
      FactoryGirl.create(:dap, farmer: Farmer.all.sample)
    rescue => e

    end
  end

  100.times do
    begin
      FactoryGirl.create(:farmer_family, farmer: Farmer.all.sample)
    rescue => e

    end
  end

  90.times do
    group = Group.all.sample
    if(group.farmers.count > 0)
      FactoryGirl.create(:set_suplente, group: group, farmer: group.farmers.sample)
    end
  end

  200.times do
    begin
      farmer = Farmer.all.sample
      production_unity = FactoryGirl.create(:production_unity_normal, group: farmer.group)
      FactoryGirl.create(:production_unity_farmer, farmer: farmer, production_unity: production_unity, is_responsible: true)
      scope_product = FactoryGirl.create(:production_unity_scope_to_production_unity, production_unity: production_unity, scope: Scope.all.sample)
      rand(30).times do
        FactoryGirl.create(:scope_product_production_unity, production_unity_scope: scope_product, product: Product.all.sample)
      end
    rescue => e

    end
  end

  115.times do
    begin
      farmer = Farmer.all.sample
      production_unity = FactoryGirl.create(:cpf_agribusiness, group: farmer.group)
      FactoryGirl.create(:production_unity_farmer, farmer: farmer, production_unity: production_unity, is_responsible: true)
      scope_product = FactoryGirl.create(:producion_unity_scope_to_agribusiness, production_unity: production_unity, scope: Scope.all.sample)
      rand(30).times do

        FactoryGirl.create(:scope_product_agribusiness, production_unity_scope: scope_product, product: Product.all.sample)

      end
    rescue => e
      puts e.message
    end
  end

  115.times do
    begin
      farmer = Farmer.all.sample
      production_unity = FactoryGirl.create(:cnpj_agribusiness, group: farmer.group)
      FactoryGirl.create(:production_unity_farmer, farmer: farmer, production_unity: production_unity, is_responsible: true)
      scope_product = FactoryGirl.create(:producion_unity_scope_to_agribusiness, production_unity: production_unity, scope: Scope.all.sample)
      rand(30).times do
        FactoryGirl.create(:scope_product_agribusiness, production_unity_scope: scope_product, product: Product.all.sample)
      end
    rescue => e
      puts e.message
    end
  end

  100.times do
    begin
      farmer = Farmer.all.sample
      FactoryGirl.create(:production_unity_farmer, farmer: farmer, production_unity: farmer.group.production_unities.sample)
    rescue => e
      puts e.message
    end
  end

  FactoryGirl.create(:system_setting)
end
