json.array!(@certificate_groups) do |certificate_group|
  json.extract! certificate_group, :id, :meeting_number, :meeting_page, :meeting_date, :group_id
  json.url certificate_group_url(certificate_group, format: :json)
end
