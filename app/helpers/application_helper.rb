module ApplicationHelper
  def rating_rounding(num)
    num.nan? ? 0 : num.round(1)
  end
end
