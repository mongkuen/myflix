module ApplicationHelper
  def rating_rounding(num)
    num.nan? ? 0 : num.round(1)
  end

  def category_selection
    Category.all.map { |category| [category.name, category.id] }
  end
end
