class ReportsBase
  def header
    image "#{Rails.root}/app/assets/images/logo.png", width: 200
    text_box 'ASSOCIAÇÃO ECOVIDA DE CERTIFICAÇÃO PARTICIPATIVA', align: :center, size: 15, at: [180, 790], width: 250, style: :bold
    text_box "Relatório:", align: :left, at: [430, 790], style: :bold
    text_box report_name, at: [430, 778], size: 10
    text_box "Data:", align: :left, at: [430, 765], style: :bold
    text_box "#{@report_date}", at: [465, 765]
  end

  def body
    bounding_box([20, 720], width: bounds.width) do
      body_header
      move_down 10
      body_data
    end
  end

  def body_header
  end

  def make_header_cell(content, width, size = 8)
    make_cell(
      content: content,
      size: size,
      font_style: :bold,
      borders: [:left, :right, :top],
      background_color: 'FFFFFF',
      width: width,
      padding: [2, 2, 4, 4],
    )
  end

  def make_information_cell(content, width, size = 10)
    make_cell(
      content: content,
      size: size,
      width: width,
      align: :left
    )
  end

  def body_data
    raise 'Please, implement body_data'
  end

  def report_name
    raise 'Please inform report_name'
  end

  def build(params)
    @report_date = Date.today.strftime('%d/%m/%Y')

    build_data(params)

    header
    body

    self
  end

  def build_data(params)
    raise 'Please, implement build_Data'
  end
end
