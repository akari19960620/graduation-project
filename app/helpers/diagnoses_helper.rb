module DiagnosesHelper
  # categoryの値に応じて、日本語の表示名を返すメソッド
  def category_name(category)
    case category
    when "cost"
      "費用重視"
    when "facility"
      "環境重視"
    when "medical"
      "医療重視"
    else
      category
    end
  end
end
