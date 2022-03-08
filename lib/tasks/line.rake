namespace :line do
  desc "デフォルトのリッチメニューの作成"
  task create_default_rich_menu: :environment do
    Line::RichMenu.create_default_rich_menu
  end
end
