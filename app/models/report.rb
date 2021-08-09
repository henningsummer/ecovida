class Report
	# ~ Quantity ~ #
		# ~ - Farmers - ~#
	def self.farmers_with_dap
		farmers = []
		Farmer.all.each do |farmer|
			if farmer.dap_due_date
				farmers << farmer if farmer.dap_due_date > Time.now()
			end
		end

		Farmer.where(id: farmers.map{|farmer|  farmer.id}).count
	end

	def self.farmers_with_dac
		farmers = []
		Farmer.all.each do |farmer|
			if farmer.dac_due_date
				farmers << farmer if farmer.dac_due_date > Time.now() + 365
			end
		end

		Farmer.where(id: farmers.map{|farmer|  farmer.id}).count
	end

	def self.farmers_suspended(count= true)
		farmers = []
		Farmer.all.each do |farmer|
			farmers << farmer if farmer.is_suspended?
		end

		return Farmer.where(id: farmers.map{|farmer| farmer.id}).count if count
		Farmer.where(id: farmers.map{|farmer| farmer.id})
	end

	def self.documents_ok_without_suspension
		farmers = []
		farmers_suspended(false).each do |farmer|
			farmers << farmer if farmer.documents_ok?
		end

		Farmer.where(id: farmers.map{|farmer| farmer.id}).count
	end

	def self.farmer_with_sig_org_equals status
		farmers = []
		Farmer.all.each do |farmer|
			farmers << farmer if farmer.sig_org_status == status
		end

		Farmer.where(id: farmers.map{|farmer| farmer.id}).count
	end

		# ~ - Fim farmers - ~ #
		# ~ - Inicio Production Unity ~ #

	def self.production_unity_suspended
		pus = []
		ProductionUnity.all.each do |pu|
			pus << pu if pu.is_suspended?
		end

		ProductionUnity.where(id: pus.map{|pu| pu.id}).count
	end


		# ~ - Fim Production Unity ~ #
	# ~ Fim QUantity ~ #
end