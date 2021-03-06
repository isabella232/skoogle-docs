module SkoogleDocs
  # SkoogleDocs Session object handles authentication with the Google API
  #
  # @api public
  class Session
    # Only use V2 of Google Drive's API
    API_VERSION = "v2"

    # Instantiates a new SkoogleDocs::Session object
    #
    # @param client [SkoogleDocs::Configuration] the config object with
    #   Google API credentials
    #
    # @raise [SkoogleDocs::Error::AuthorizationError] if client credentials are
    #   invalid
    #
    # @return [SkoogleDocs::Session]
    def initialize(config)
      unless config.credentials?
        raise SkoogleDocs::Errors::BadAuthenticationData
      end

      @config = config
      configure_google_client
    end

    # Wrapper to the Google Drive API
    #
    # @return [Google::APIClient::API]
    def api
      @drive
    end

    # Wraps requests to the Google API
    #
    # @param params [Hash] filters and api method for the request
    #
    # @return [Google::APIClient::Result]
    #
    # @example Requesting Google Drive API
    #   session = SkoogleDocs::Session.new(client)
    #   files = session.execute(api_method: session.api.files.get)
    def execute(params)
      @google_client.execute(params)
    end

    private

    # Initializes a Google API Client and opens the Drive api
    #
    # @api private
    #
    # @return [nil]
    def configure_google_client
      @google_client = Google::APIClient.new(@config.application_info)
      @google_client.retries = 2
      @drive = @google_client.discovered_api("drive", API_VERSION)
      authorize
    end

    # Runs oauth flow to use the Google API
    #
    # @api private
    #
    # @return [nil]
    def authorize
      auth = @google_client.authorization
      auth.client_id = @config.client_id
      auth.client_secret = @config.client_secret
      auth.redirect_uri = @config.redirect_uri
      auth.scope = @config.permission_scope
      auth.code = @config.auth_code
      fetch_access_token(auth)
    end

    # Wraps the access token request
    #
    # @api private
    #
    # @raise [SkoogleDocs::Error::AuthorizationError] if credentials are invalid
    #
    # @return [nil]
    def fetch_access_token(auth)
      auth.fetch_access_token!
    rescue Signet::AuthorizationError
      raise SkoogleDocs::Errors::AuthorizationError
    end
  end
end
