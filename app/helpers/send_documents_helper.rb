module SendDocumentsHelper
  PANEL_COLORS = {
    pending: 'panel-warning',
    accepted: 'panel-success',
    change_request: 'panel-danger'
  }

  SEND_STATUSES = {
    pending: 'Documento enviado, porém, aguardando a aprovação de um administrador',
    accepted: 'Documento enviado e aceito.',
    change_request: 'Document enviado, porém recusado. Necessário o re-envio'
  }
  def document_sended_for(document, sended_documents)
    return false unless sended_documents.try(:map, &:document).try(:include?, document)

    document_sended = sended_documents.select { |snd| snd.document == document }.first
  end

  def send_document_status(document, sended_documents)
    sended = document_sended_for(document, sended_documents)
    return 'Documento NÃO enviado' unless sended

    SEND_STATUSES[sended.status.to_sym]
  end

  def panel_color(document, sended_documents)
    sended = document_sended_for(document, sended_documents)
    return '' unless sended

    PANEL_COLORS[sended.status.to_sym]
  end

  def panel_color_dac(dac_document)
    return '' unless dac_document

    return 'panel-danger'  if dac_document.group.expirated_dac? && dac_document.status == 'accepted'

    PANEL_COLORS[dac_document.status.to_sym]
  end

  def panel_status_dac(dac_document)
    return 'Documento NÃO enviado' unless dac_document

    return 'D.A.C Vencida' if dac_document.group.expirated_dac? && dac_document.status == 'accepted'

    SEND_STATUSES[dac_document.status.to_sym]
  end
end
