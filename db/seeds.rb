# ユーザー
# 管理者
user = User.create!(
  last_name: "山田",
  first_name: '太郎',
  email: 'sample@example.com',
  password: 'password',
  password_confirmation: 'password'
)

# 従業員
29.times do |i|
  first_name = i.to_s
  email = "sample#{i}@example.com"
  User.create!(
    last_name: "従業員",
    first_name: first_name,
    email: email,
    password: 'password',
    password_confirmation: 'password'
  )
end
  
# 企業
company = Company.create!(
  name: '滋賀工業株式会社'
)

# 支店
branch = company.branches.create!(
  name: '草津支店'
)
other_branch = company.branches.create!(
  name: '栗東支店'
)

# relationship
Relationship.create!(user: user, branch: branch, master: true, admin: true)
Relationship.create!(user: user, branch: other_branch)
User.all[1..10].each do |user|
  user.relationships.create!(branch: branch)
end