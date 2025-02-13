defmodule TwitterCloneWeb.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :my_app,
    module: TwitterClone.Guardian,
    error_handler: TwitterCloneWeb.AuthErrorHandler

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.LoadResource
end
