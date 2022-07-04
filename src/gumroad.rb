require 'sketchup.rb'
require 'extensions.rb'

module DeveloperMeetUp
  module GumroadExample
    NAME = 'Gumroad Example'.freeze
    FOLDER_NAME = File.basename(__FILE__)[0...-3].freeze
    DIR = File.dirname(__FILE__) unless defined?(self::DIR)
    DESCRIPTION = 'Gumroad License API Example.'.freeze
    VERSION = '0.0.1'.freeze

    MAC = RUBY_PLATFORM =~ /(darwin)/i ? true : false
    WIN = RUBY_PLATFORM =~ /(mswin|mingw)/i ? true : false

    unless defined?(@loaded)
      EXTENSION = SketchupExtension.new(NAME, "#{FOLDER_NAME}/load")
      EXTENSION.description = DESCRIPTION
      EXTENSION.version     = VERSION
      EXTENSION.copyright   = 'Developer MeetUp © 2022'
      EXTENSION.creator     = 'Developer MeetUp'
      Sketchup.register_extension(EXTENSION, true)
      @loaded = true
    end
  end
end
