# Preview all emails at http://localhost:3000/rails/mailers/employee_mailer
class EmployeeMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/employee_mailer/add_new_user
  def add_new_user
    branch = Branch.first
    email = "new_user@example.com"
    EmployeeMailer.add_new_user(branch, email)
  end

  # Preview this email at http://localhost:3000/rails/mailers/employee_mailer/add_existing_user
  def add_existing_user
    branch = Branch.first
    user = User.first
    EmployeeMailer.add_existing_user(branch, user)
  end

end
