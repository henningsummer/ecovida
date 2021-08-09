class DocumentSubjects < EnumerateIt::Base
  associate_values(
    :farmer,
    :core_group,
    :production_unity,
    :agribusiness
  )
end
