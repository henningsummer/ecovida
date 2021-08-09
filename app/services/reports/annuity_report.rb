module Reports
  class AnnuityReport
    def initialize(cores, year)
      @cores = cores
      @year = year
    end

    def process(email)
      pdf = AnnuityReportPdf.build({ cores: @cores, in_force_year: @year })
      pdf.render_file('tmp/report.pdf')

      ReportSender.delay.report_sender(email, 'Relatório das anuidades', 'tmp/report.pdf', 'relatório_de_anuidades')
    end

    handle_asynchronously :process
  end
end
