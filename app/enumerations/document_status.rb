class DocumentStatus < EnumerateIt::Base
  associate_values(
    :pending,
    :accepted,
    :change_request
  )
end
