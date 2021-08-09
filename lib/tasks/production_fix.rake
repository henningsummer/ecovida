namespace :production_fix do
  desc 'Set Next Farmer Count'
  task next_farmer_count: :environment do
    Core.find_each do |core|
      Farmer.unscoped {
        core.update(next_farmer_count: core.farmers.count)
      }
    end

    Farmer.unscoped {
      CertificateName.where.not(farmer_id: nil).each do |certificate_name|
        certificate_name.update(farmer_code: certificate_name.farmer.farmer_code)
      end
    }
    puts "Task Completed Successfully"
  end
end
