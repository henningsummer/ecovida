class Genders < EnumerateIt::Base
  associate_values(
    :male,
    :female
  )
end
