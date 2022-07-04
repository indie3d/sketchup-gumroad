module DeveloperMeetUp
  module GumroadExample
    Sketchup.require "#{FOLDER_NAME}/modules/gumroad"
    Sketchup.require "#{FOLDER_NAME}/modules/callbacks"
    Sketchup.require "#{FOLDER_NAME}/debug"
    # # #
    class Main
      include Gumroad
      include Callbacks

      attr_accessor :menu

      def initialize(menu)
        @menu = menu # ['run', 'licensing']
      end

      def activate
        if @menu == 'run'
          unless check_gumroad_offline && verify_env
            html_file = File.join(DIR, "#{FOLDER_NAME}/webflow/ui/lic.html")
            setup_dlg(html_file)
            return
          end
        end

        if @menu == 'licensing'
          if check_gumroad_offline && verify_env
            html_file = File.join(DIR, "#{FOLDER_NAME}/webflow/ui/licensed.html")
          else
            html_file = File.join(DIR, "#{FOLDER_NAME}/webflow/ui/lic.html")
          end
          setup_dlg(html_file)
          exit_tool
          return
        end

        # # # # # # # # # # # #
        # Gumroad is Licensed #
        # Run Code Below      #
        # # # # # # # # # # # #
        UI.messagebox('Hello World!', MB_OK)
        exit_tool
      end

      def exit_tool
        Sketchup.active_model.select_tool(nil)
      end
    end
  end
end
