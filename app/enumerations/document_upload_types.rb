class DocumentUploadTypes < EnumerateIt::Base
  associate_values(
    :only_pdf,
    :only_video,
    :pdf_and_video
  )
end
