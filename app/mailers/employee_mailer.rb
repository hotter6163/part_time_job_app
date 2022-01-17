class EmployeeMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.employee_mailer.add_new_user.subject
  #
  def add_new_user
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.employee_mailer.add_existing_user.subject
  #
  def add_existing_user
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
