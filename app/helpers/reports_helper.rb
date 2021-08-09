module ReportsHelper
	def percent_of(total, amount)
	if total > 0
		"#{((amount * 100) / total).round(2)}%"
	else
		"0%"
	end
	end
end
