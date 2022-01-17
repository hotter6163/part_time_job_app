# Preview all emails at http://localhost:3000/rails/mailers/employee_mailer
class EmployeeMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/employee_mailer/add_new_user
  def add_new_user
    EmployeeMailer.add_new_user
  end

  # Preview this email at http://localhost:3000/rails/mailers/employee_mailer/add_existing_user
  def add_existing_user
    EmployeeMailer.add_existing_user
  end

end
