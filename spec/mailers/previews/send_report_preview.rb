# Preview all emails at http://localhost:3000/rails/mailers/send_report
class SendReportPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/send_report/send
  def send
    report = Reports::ActualSituationReport.new(Core.all.limit(1)).process.generate('report.odt')

    SendReport.send_report('otavioschwanck@gmail.com', 'Relatório X', 'report.odt', 'Produtos de Casas Bahia')
  end
end
