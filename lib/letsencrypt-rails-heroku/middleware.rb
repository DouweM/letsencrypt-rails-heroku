module Letsencrypt
  class Middleware

    def initialize(app)
      @app = app
    end

    def call(env)
      if env["PATH_INFO"].include?(".well-known/acme-challenge")
        puts env["PATH_INFO"].inspect
        acme_challenge_filename = env["PATH_INFO"]
        acme_challenge_filename[0] = ""
        if Letsencrypt.challenge_configured?(acme_challenge_filename)
          return [200, {"Content-Type" => "text/plain"}, [Letsencrypt.configuration.acme_challenges[acme_challenge_filename]]]
        end
      end

      @app.call(env)
    end

  end
end
