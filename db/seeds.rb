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

# 店舗情報
branch = company.branches.create!(
  name: '草津支店',
  display_day: 0,
  start_of_business_hours: '8:30',
  end_of_business_hours: '21:00',
  period_type: 0
)
branch.create_weekly!(
  start_day: 1, 
  deadline_day: 8,
  num_of_weeks: 2
)
branch.create_periods("2022-02-07".in_time_zone)

other_branch = company.branches.create!(
  name: '栗東支店',
  display_day: 1,
  start_of_business_hours: '9:00',
  end_of_business_hours: '24:00',
  period_type: 1,
  cross_day: 1  
)
monthly = other_branch.create_monthly!(period_num: 2)
monthly.monthly_periods.create!(
  start_day: 1,
  end_day: 15,
  deadline_day: 20
)
monthly.monthly_periods.create!(
  start_day: 16,
  end_day: 30,
  deadline_day: 5
)
other_branch.create_periods("2022-02-01".in_time_zone)

# relationship
Relationship.create!(user: user, branch: branch, master: true, admin: true)
Relationship.create!(user: user, branch: other_branch)
User.all[1..10].each do |user|
  user.relationships.create!(branch: branch)
end