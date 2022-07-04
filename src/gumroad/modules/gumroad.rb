module DeveloperMeetUp
  module GumroadExample
    module Gumroad

      require 'net/http'
      require 'uri'

      def encode(text)
        text.tr(ALPHABET, ENCODING)
      end

      def decode(text)
        text.tr(ENCODING, ALPHABET)
      end

      def check_gumroad_offline
        json = File.join(PATH, 'gum.json')

        if File.exist?(json)
          file = File.read(json)
          file = decode(file)
          data_hash = JSON.parse(file)
          if data_hash['success'] == true || data_hash['success'] == false
            return data_hash['success']
          else
            return false
          end
        else
          puts "JSON file doesn't exist"
          # TO-DO - Create JSON file...
          msg_connect_online unless Sketchup.is_online
          return false
        end
      end

      # Online License Validation with Gumroad API
      def check_gumroad(license_key, product_permalink)
        uri = URI.parse('https://api.gumroad.com/v2/licenses/verify')
        request = Net::HTTP::Post.new(uri)
        request.set_form_data(
          'license_key' => license_key,
          'product_permalink' => product_permalink
        )
        req_options = {
          use_ssl: uri.scheme == 'https'
        }
        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
          http.request(request)
        end
        hash_response = JSON.parse(response.body)
        # # # Write to JSON file # # #
        FileUtils.mkdir_p PATH
        # # #
        enc = encode(hash_response.to_json)
        File.open(PATH + 'gum.json', 'w') { |f| f.write(enc) }

        # # # ENV JSON # # #
        env = { 'env' => PATH }
        envjson = env.to_json
        enc = encode(envjson)
        File.open(PATH + 'env.json', 'w') { |f| f.write(enc) }

        # # #
        hash_response['success']
      end

      def msg_connect_online
        UI.beep
        msg = 'Please connect to the internet to validate license key'
        UI.messagebox(msg, MB_OK)
        Sketchup.active_model.select_tool(nil)
      end

      # Verify ENV
      def verify_env
        json = File.join(PATH, 'env.json')
        if File.exist?(json)
          file = File.read(json)
          file = decode(file)
          data_hash = JSON.parse(file)
          return PATH == data_hash['env']
        else
          return false
        end
      end
      # # #
    end
  end
end
