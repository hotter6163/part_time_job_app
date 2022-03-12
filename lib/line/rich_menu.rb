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
        
        file = File.new('./lib/assets/rich_menu_before_link.png')
        client.create_rich_menu_image(rich_menu_id, file)
        file.close
        
        client.set_default_rich_menu(rich_menu_id)
      end
      
      def create_rich_menu_for_linked_user(user, line_id)
        rich_menu = {
          size: {
            width: 2500,
            height: 843
          },
          selected: true,
          name: "#{user.full_name}'s rich menu",
          chatBarText: "メニューを開く",
          areas: [
            {
              bounds: {
                x: 0,
                y: 0,
                width: 832,
                height: 843
              }, 
              action: {
                type: "postback",
                data: "action=destroy_link"
              }
            },
            {
              bounds: {
                x: 834,
                y: 0,
                width: 832,
                height: 843
              }, 
              action: {
                type: "postback",
                data: "action=shift_submission"
              }
            },
            {
              bounds: {
                x: 1668,
                y: 0,
                width: 832,
                height: 843
              }, 
              action: {
                type: "postback",
                data: "action=show_submitted_shift"
              }
            }
          ]
        }
        
        res = client.create_rich_menu(rich_menu)
        rich_menu_id = JSON.parse(res.body)["richMenuId"]
        file_path = Rails.root.to_s + "/lib/assets/rich_menu_for_linked_user.png"
        
        file = File.new(file_path)
        client.create_rich_menu_image(rich_menu_id, file)
        file.close
        
        client.link_user_rich_menu(line_id, rich_menu_id)
      end
    end
  end
end