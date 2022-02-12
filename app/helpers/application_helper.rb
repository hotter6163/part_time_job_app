module ApplicationHelper
  include BranchesHelper
  include CompanyRegistrationsHelper
  include RelationshipsHelper
  include StaticPagesHelper
  include ShiftSubmissionsHelper
  
  def day_pull_down
    [["日曜日", 0], ["月曜日", 1], ["火曜日", 2], ["水曜日", 3], ["木曜日", 4], ["金曜日", 5], ["土曜日", 6]]
  end
  
  def date_pull_down
    (1..30).inject([]) do |result, n|
      if n == 1
        result << ["1（初日）", n]
      elsif n == 30
        result << ["30（末日）", n]
      else
        result << [n, n]
      end
    end
  end
  
  # sessionに追加
  def add_sessions(args)
    args.each { |key, value| session[key.to_sym] = value }
  end
  
  # sessionの特定の値を削除
  def delete_sessions(*ary)
    ary.each { |key| session[key] = nil }
  end
  
  def correct_key?(key)
    correct_keys = Set.new(["primary", 'secondaly', "success", "danger", "warning", "info", "light", "dark"])
    correct_keys.include?(key)
  end
  
  def col_size_for_form_label
    "col-md-2"
  end
  
  def col_size_for_form_input
    "col-md-10"
  end
end
