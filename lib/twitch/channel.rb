module Twitch
  class Channel

    include Initializable

    attr_accessor :broadcaster_id, :broadcaster_name, :game_name, :game_id, :broadcaster_language, :title, :delay

    class << self

      # Gets a specified channel object
      def get(id)
        response = Twitch.client.get(:helix, "channels?broadcaster_id=#{id}")

        new(response["data"][0])
      end

      # Gets a specified channel object
      def update(id, params={})
        Twitch.client.patch(:helix, "channels?broadcaster_id=#{id}", params)
      end

    end

  end
end
