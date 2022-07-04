module DeveloperMeetUp
  module GumroadExample
    module Callbacks
      # ------------------------------------------------------------------------
      # HTML Dialog Methods
      # ------------------------------------------------------------------------
      def html_properties
        {
          dialog_title: "#{NAME} v#{VERSION}",
          preferences_key: 'com.sample.plugin',
          scrollable: false,
          resizable: true,
          width: 420,
          height: 320,
          left: 0,
          top: 0,
          min_width: 240,
          min_height: 240,
          max_width: 1920,
          max_height: 1080,
          style: UI::HtmlDialog::STYLE_DIALOG
        }
      end

      def initialize_html
        @dlg ||= UI::HtmlDialog.new(html_properties)
        @dlg.show

        MENU.set_validation_proc(ITEM1) { MF_GRAYED }
        MENU.set_validation_proc(ITEM2) { MF_GRAYED }
        TB.to_a[0].set_validation_proc { MF_DISABLED }

        @dlg.set_on_closed do
          MENU.set_validation_proc(ITEM1) { MF_ENABLED }
          MENU.set_validation_proc(ITEM2) { MF_ENABLED }
          TB.to_a[0].set_validation_proc { MF_ENABLED }
          Sketchup.active_model.select_tool(nil)
        end
        action_callback if !@dlg.nil?
      end

      def setup_dlg(html_file)
        initialize_html if @dlg.nil?
        @dlg.set_file(html_file)
        @dlg.center
      end

      def costumer_email
        json = File.join(PATH, 'gum.json')

        return unless File.exist?(json)

        file = File.read(json)
        file = decode(file)
        data_hash = JSON.parse(file)

        if data_hash.key?('purchase')
          @email = data_hash['purchase']['email']
        else
          @email = 'No email'
        end
        @email
      end

      # ------------------------------------------------------------------------
      # Callbacks
      # ------------------------------------------------------------------------
      def action_callback
        # -----------------------------
        # Set Size (x,y)
        # -----------------------------
        @dlg.add_action_callback('say_size') do |_action_context, x, y|
          @dlg.set_size(x, y)
          @dlg.center
        end

        # -----------------------------
        # Set Purchase Email
        # -----------------------------
        @dlg.add_action_callback('email') do
          js_command = "document.getElementById('purchase-email').textContent='#{costumer_email}';"
          @dlg.execute_script(js_command)
        end

        # -----------------------------
        # Deactivate License Key
        # -----------------------------
        @dlg.add_action_callback('remove_license') do
          msg = "WARNING! \n Do you want to eliminate license for #{NAME}?"
          result = UI.messagebox(msg, MB_YESNO)
          if result == IDYES
            json = File.join(PATH, 'gum.json')
            temp_hash = {
              'success' => false,
              'message' => 'That license does not exist for the provided product.'
            }
            enc = encode(temp_hash.to_json)
            File.open(json, 'w') { |f| f.write(enc) }

            html_file = File.join(DIR, "#{FOLDER_NAME}/webflow/ui/lic.html")
            setup_dlg(html_file)
          end
        end

        # -----------------------------
        # Purchase License Key
        # -----------------------------
        @dlg.add_action_callback('buy') do
          url = 'https://indie3d.gumroad.com/l/sketchup-gumroad'
          UI.openURL(url)
          @dlg.close
          exit_tool
        end

        # -----------------------------
        # Close
        # -----------------------------
        @dlg.add_action_callback('close') do
          @dlg.close
        end

        # ------------------------------------------------------------------------
        # Activate License Key - (Activate)
        # ------------------------------------------------------------------------
        @dlg.add_action_callback('license') do |_action_context, license|
          if check_gumroad(license, 'sketchup-gumroad')
            html_file = File.join(DIR, "#{FOLDER_NAME}/webflow/ui/licensed.html")
            setup_dlg(html_file)
          else
            msg = "The license key is NOT valid. \n Do you want to get a license?"
            result = UI.messagebox(msg, MB_YESNO)
            if result == IDYES
              UI.openURL('https://indie3d.gumroad.com/l/sketchup-gumroad')
              @dlg.close
              exit_tool
            end
          end
        end
      end
      # # #
    end
  end
end
