require "prawn/measurement_extensions"

class AnnuityReportPdf < ReportsBase
  include Prawn::View

  def self.build(params)
    new.build(params)
  end

  def initialize
    @document = Prawn::Document.new(
      page_size: 'A4',
      page_layout: :portrait,
      left_margin: 5.mm,
      right_margin: 5.mm,
      top_margin: 5.mm,
      bottom_margin: 5.mm)
  end

  def body_header
    text "Ano vigente: #{@in_force_year}"
  end

  private

  def build_data(params)
    @cores = params[:cores]
    @in_force_year = params[:in_force_year]
    @total_members_without_property = 0
    @total_farmers_with_property = 0
    @total_agribusiness = 0
    @total_total_paid = 0
    @total_to_pay = 0
  end

  def body_data
    core_data
    total_core_data
  end

  def report_name
    'Situação atual das anuidades'
  end

  def core_data
    cell_width = 90
    members_without_property_header = make_header_cell('Membros sem propriedade', cell_width)
    farmers_with_property_header = make_header_cell('Agricultores(as) com propriedade cadastrada', cell_width)
    agribusiness_header = make_header_cell('Agroindústrias', cell_width)
    total_paid_header = make_header_cell('Total pago', cell_width)
    payment_date_header = make_header_cell('Data do pagamento/depósito', cell_width)
    to_pay_header = make_header_cell('Total a pagar', cell_width)

    headers = [
      members_without_property_header,
      farmers_with_property_header,
      agribusiness_header,
      total_paid_header,
      payment_date_header,
      to_pay_header
    ]

    core_information_cells = []
    cores_on_page = 0
    @cores.each do |core|
      payments = CorePayment.search_by_year(@in_force_year).result(distinct: true).where(core: core)
      summarized = core.summarizing(@in_force_year.to_i)
      payed = payments.map(&:amount).reduce(:+).to_f
      to_pay = summarized[:amount] - payed
      payment_date = payments.last.try(:payment_date).try(:strftime, '%d/%m/%Y') || 'Sem pagamento'
      agribusiness_count = summarized[:agribusiness]
      members_without_property = summarized[:unproductive]
      farmers_with_property = summarized[:productive]

      @total_to_pay += to_pay
      @total_total_paid += payed
      @total_agribusiness += agribusiness_count
      @total_farmers_with_property += farmers_with_property
      @total_members_without_property += members_without_property

      members_without_property_cell = make_information_cell("#{members_without_property}", cell_width)
      farmers_with_property_cell = make_information_cell("#{farmers_with_property}", cell_width)
      agribusiness_cell = make_information_cell("#{agribusiness_count}", cell_width)
      total_paid_cell = make_information_cell("#{helper.number_to_currency(payed)}", cell_width)
      payment_date_cell = make_information_cell("#{payment_date}", cell_width)
      to_pay_cell = make_information_cell("#{helper.number_to_currency(to_pay)}", cell_width)

      core_information_cells = [
        members_without_property_cell,
        farmers_with_property_cell,
        agribusiness_cell,
        total_paid_cell,
        payment_date_cell,
        to_pay_cell
      ]

      core_information_table = [
        headers
      ]

      core_information_table.concat([core_information_cells])
      text "Núcleo: #{core.name}", style: :bold
      table(core_information_table)
      move_down 20
      cores_on_page += 1

      if cores_on_page == 7
        cores_on_page = 0
        start_new_page
      end
    end
  end

  def total_core_data
    cell_width = 108
    members_without_property_header = make_header_cell('Membros sem propriedade', cell_width)
    farmers_with_property_header = make_header_cell('Agricultores(as) com propriedade cadastrada', cell_width)
    agribusiness_header = make_header_cell('Agroindústrias', cell_width)
    total_paid_header = make_header_cell('Total pago', cell_width)
    to_pay_header = make_header_cell('Total a pagar', cell_width)

    headers = [
      members_without_property_header,
      farmers_with_property_header,
      agribusiness_header,
      total_paid_header,
      to_pay_header
    ]

    members_without_property_cell = make_information_cell("#{@total_members_without_property}", cell_width)
    farmers_with_property_cell = make_information_cell("#{@total_farmers_with_property}", cell_width)
    agribusiness_cell = make_information_cell("#{@total_agribusiness}", cell_width)
    total_paid_cell = make_information_cell("#{helper.number_to_currency(@total_total_paid)}", cell_width)
    to_pay_cell = make_information_cell("#{helper.number_to_currency(@total_to_pay)}", cell_width)

    total_core_information_cells = [
      members_without_property_cell,
      farmers_with_property_cell,
      agribusiness_cell,
      total_paid_cell,
      to_pay_cell
    ]

    total_core_information_table = [
      headers
    ]

    total_core_information_table.concat([total_core_information_cells])
    text 'Total geral', style: :bold
    table(total_core_information_table)
  end

  def make_header_cell(content, width)
    make_cell(
      content: content,
      size: 8,
      font_style: :bold,
      borders: [:left, :right, :top],
      background_color: 'FFFFFF',
      width: width,
      padding: [2, 2, 4, 4],
    )
  end

  def make_information_cell(content, width)
    make_cell(
      content: content,
      size: 10,
      width: width,
      align: :left
    )
  end

  def helper
    @helper ||= Class.new do
      include ActionView::Helpers::NumberHelper
    end.new
  end
end
