module PendingDocumentsHelper
  def dac_status(group)
    dac_document = group.dac_documents.last
    return 'DAC: Documento não enviado.' unless dac_document

    dac_expiration_date = dac_document.try(:dac_date).present? ? dac_document.try(:dac_date) + 1.year : false

    dac_date_text = ''
    if dac_expiration_date
      text = dac_expiration_date < Time.now ? 'DAC Vencida em' : 'DAC Vence em'
      dac_date_text << text
      dac_date_text << " #{dac_expiration_date.strftime('%d/%m/%Y')}."
    end

    case dac_document.status
    when 'pending'
      return "DAC: Documento enviado e aguardando aprovação. #{dac_date_text}"
    when 'change_request'
      return "DAC: Documento enviado, porém, OPAC recusou devido a problemas no mesmo. #{dac_date_text}"
    when 'accepted'
      return "DAC: Documento enviado, porém, #{dac_date_text}" if group.expirated_dac?
    end

    :success
  end
end