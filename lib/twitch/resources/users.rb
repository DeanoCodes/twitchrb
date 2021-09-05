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
      Collection.from_response(response, type: FollowedUser)
    end

    # Required scope: user:read:blocked_users
    def blocks(broadcaster_id:, **params)
      response = get_request("users/blocks?broadcaster_id=#{broadcaster_id}", params: params)
      Collection.from_response(response, type: BlockedUser)
    end

    # Required scope: user:manage:blocked_users
    def block_user(target_user_id:, **attributes)
      put_request("users/blocks?target_user_id=#{target_user_id}", body: attributes)
    end

    # Required scope: user:manage:blocked_users
    def unblock_user(target_user_id:)
      delete_request("users/blocks?target_user_id=#{target_user_id}")
    end

    # A quick method to see if a user is following a channel
    def following?(from_id:, to_id:)
      response = get_request("users/follows", params: {from_id: from_id, to_id: to_id})

      if response.body["data"].empty?
        false
      else
        true
      end
    end

  end
end
