module ApplicationHelper
  include BranchesHelper
  include CompanyRegistrationsHelper
  include RelationshipsHelper
  include StaticPagesHelper
  
  def create_new_user(sign_up_params)
    build_resource(sign_up_params)

    resource.save
    resource
  end
  
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
end
