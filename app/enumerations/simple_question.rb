class SimpleQuestion < EnumerateIt::Base
  associate_values(
    :yes_answer,
    :no_answer,
  )
end
