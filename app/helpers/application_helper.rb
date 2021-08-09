module ApplicationHelper
  def pluralize_without_count count, singular, plural=nil
    ((count == 1 || count =~ /^1(\.0+)?$/) ? singular : (plural || singular.pluralize))
  end

  def query_message(state, query, sig_org = nil)
    #Monta a mensagem de query, se caso for nul, não faz nada
    if @state.present? or @query.present? or sig_org == "1"
      text = 'Resultados da busca '
      text += "de '#{query}' " if query.present?
      text += "no estado: #{state.name} " if state.present?
      text += "apenas com SigOrg desatualizado" if sig_org == "1"
      text
    end
  end

  def current_user_admin?
    return true if user_type == 4
  end

  def show_errors(object)
    if object.errors.any?
      msg ="<div id='error_explanation' class = 'alert alert-danger'>
              <h2> #{pluralize(object.errors.count, 'erro')} #{pluralize_without_count(object.errors.count, 'foi', 'foram').sub(/d+s/, '')} #{pluralize_without_count(object.errors.count, 'encontrado')} :</h2>

              <ul>"
      object.errors.full_messages.each do |message|
        msg += "<li>#{message} </li>"
      end
      msg+="</ul></div>"
      msg.html_safe
    end
  end

  def create_breadcumbs(breadcumbs)
    text = '<p>'
    breadcumbs.each do |breadcumb|
      next if breadcumb[:hide]
      if breadcumbs.last != breadcumb
        text << link_to(breadcumb[:text], "#{breadcumb[:url]}")
        text << " - "
      else
        text << breadcumb[:text]
      end
    end
    text << '<p>'
    text.html_safe
  end

  def formated_datetime(date)
    return unless date.present?

    date.to_datetime.try(:strftime, '%d/%m/%Y - %H:%M')
  end

  def formated_date(date)
    date.to_date.try(:strftime, '%d/%m/%Y')
  end

  def rounded_formated_value(value)
    value = value.to_f if value.is_a?(String)
    value.try(:round, 3).to_s.tr('.', ',')
  end
end
