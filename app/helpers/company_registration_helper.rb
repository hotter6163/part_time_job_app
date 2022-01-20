module CompanyRegistrationHelper
  # sessionに企業登録の情報があるかどうか
  def have_name_in_session?(syn)
    !session[:company_registration].nil? && 
    !session[:company_registration][syn.to_s].nil? 
  end
  
  # 企業情報を登録するための情報があるかどうか
  def registrate_company?
    have_name_in_session?(:company) && have_name_in_session?(:branch)
  end
  
  # 企業登録
  def company_registration
    company = Company.find_by(session[:company_registration]["company"]) || Company.create(session[:company_registration]["company"])
    branch = company.branches.create(session[:company_registration]["branch"])
    session[:company_registration] = nil
    Relationship.create(user: current_user, branch: branch, master: true, admin: true)
  end
end
