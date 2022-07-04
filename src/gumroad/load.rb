module DeveloperMeetUp
  MENU ||= UI.menu('Plugins') if Sketchup.version.to_i <= 14
  MENU ||= UI.menu('Extensions') if Sketchup.version.to_i >= 15
  MASTER_MENU ||= MENU.add_submenu('Developer MeetUp')

  module GumroadExample
    Sketchup.require "#{FOLDER_NAME}/main"

    require 'json'
    require 'fileutils'
    require 'open-uri'

    unless defined?(@loaded)
      ALPHABET = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
      ENCODING = 'MOhqm0PnycUZeLdK8YvDCgNfb7FJtiHT52BrxoAkas9RWlXpEujSGI64VzQ31w'
      PATH = ENV['HOME'] + "/Library/Application Support/i3d/#{FOLDER_NAME}/" if MAC
      PATH = ENV['APPDATA'] + "/i3d/#{FOLDER_NAME}/".gsub(/\//, '\\') if WIN
      FileUtils.mkdir_p PATH

      model = Sketchup.active_model
      # Set Icon Path & Type
      # PDF for Mac and SVG for Windows
      if MAC
        icon_format = '.pdf'
        icon_path = 'lib/assets/icons/pdf/'
      else
        icon_format = '.svg'
        icon_path = 'lib/assets/icons/svg/'
      end

      # --------------------------------
      # Plugin Menu...
      # --------------------------------
      submenu = MASTER_MENU.add_submenu(NAME)
      MASTER_MENU.add_separator
      ITEM1 = submenu.add_item('Run') do
        model.select_tool Main.new('run')
      end

      submenu.add_separator

      ITEM2 = submenu.add_item('Manage Licensing') do
        model.select_tool Main.new('licensing')
      end

      # --------------------------------
      # Add toolbar...
      # --------------------------------
      tb = UI::Toolbar.new NAME
      # Add Command...
      cmd = UI::Command.new(NAME) { model.select_tool Main.new('run') }
      cmd.small_icon = "#{icon_path}icon_1#{icon_format}"
      cmd.large_icon = "#{icon_path}icon_1#{icon_format}"
      cmd.tooltip = NAME
      cmd.status_bar_text = DESCRIPTION
      cmd.menu_text = 'Gumroad Example'
      tb.add_item cmd
      # --------------------------------
      tb.get_last_state == TB_NEVER_SHOWN ? tb.show : tb.restore
      TB = tb

      # Right click
      UI.add_context_menu_handler do |context_menu|
        context_menu.add_item(NAME) do
          model.select_tool Main.new('run')
        end
      end
      @loaded = true
    end
  end
end
