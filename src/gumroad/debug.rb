module DeveloperMeetUp
  module GumroadExample
    module Debug
      # @note Debug method to reload the plugin.
      #
      # @example
      #   DeveloperMeetUp::GumroadExample::Debug.reload
      #
      # @return [Integer] Number of files reloaded.
      def self.reload
        original_verbose = $VERBOSE
        $VERBOSE = nil
        load __FILE__
        pattern = File.join(__dir__, '**/*.rb')
        Dir.glob(pattern).each { |file| load file }.size
      ensure
        $VERBOSE = original_verbose
      end
    end
  end
end
