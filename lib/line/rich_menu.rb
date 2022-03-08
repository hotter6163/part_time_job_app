module Line
  class RichMenu
    extend Line::Client
    extend JSON
    
    class << self
      def create_default_rich_menu
        rich_menu = {
          size: {
            width: 2500,
            height: 843
          },
          selected: true,
          name: "Menu before link",
          chatBarText: "メニューを開く",
          areas: [
            {
              bounds: {
                x: 0,
                y: 0,
                width: 1250,
                height: 843
              }, 
              action: {
                type: "postback",
                data: "action=link&user=new"
              }
            },
            {
              bounds: {
                x: 1251,
                y: 0,
                width: 1250,
                height: 843
              }, 
              action: {
                type: "postback",
                data: "action=link&user=exist"
              }
            }
          ]
        }
        
        res = client.create_rich_menu(rich_menu)
        rich_menu_id = JSON.parse(res.body)["richMenuId"]
        
        f = File.new('./lib/assets/rich_menu_before_link.png')
        
        client.create_rich_menu_image(rich_menu_id, f)
        
        client.set_default_rich_menu(rich_menu_id)
        f.close
      end
    end
  end
end