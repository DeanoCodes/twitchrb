module Twitch
  class UsersResource < Resource
    
    def get_by_id(user_id:)
      User.new get_request("users/?id=#{user_id}").body.dig("data")[0]
    end

    def get_by_username(username:)
      User.new get_request("users/?login=#{username}").body.dig("data")[0]
    end

    # Updates the current users description
    # Required scope: user:edit
    def update(description:)
      response = put_request("users", body: {description: description})
      User.new response.body.dig("data")[0]
    end

    def follows(**params)
      raise "from_id or to_id is required" unless !params[:from_id].nil? || !params[:to_id].nil?

      response = get_request("users/follows", params: params)
      Collection.from_response(response, key: "data", type: FollowedUser)
    end

    # Required scope: user:read:blocked_users
    def blocks(broadcaster_id:, **params)
      response = get_request("users/blocks?broadcaster_id=#{broadcaster_id}", params: params)
      Collection.from_response(response, key: "data", type: BlockedUser)
    end

  end
end
