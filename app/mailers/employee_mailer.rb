class EmployeeMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.employee_mailer.add_new_user.subject
  #
  def add_new_user(branch, email)
    @branch = branch
    mail to: email, subject: "#{@branch.company_name}から従業員登録の申請"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.employee_mailer.add_existing_user.subject
  #
  def add_existing_user(branch, user)
    @branch = branch
    @user = user
    mail to: @user.email, subject: "#{@branch.company_name}から従業員登録の申請"
  end
end
