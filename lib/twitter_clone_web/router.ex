defmodule TwitterCloneWeb.Router do
  use TwitterCloneWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TwitterCloneWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug TwitterCloneWeb.AuthPipeline
    plug TwitterCloneWeb.Plugs.Authenticate
  end

  # Rotas públicas
  scope "/", TwitterCloneWeb do
    pipe_through [:browser]

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/logout", SessionController, :delete

    get "/register", UserController, :new
    post "/register", UserController, :create
  end

  # Rotas protegidas
  scope "/", TwitterCloneWeb do
    pipe_through [:browser, :auth]

    live "/", PageLive, :index

    live "/posts", PostLive.Index, :index
    live "/posts/new", PostLive.Index, :new
    live "/posts/:id/edit", PostLive.Index, :edit

    live "/posts/:post_id/comments", CommentLive.Index, :index
    live "/posts/:post_id/comments/new", CommentLive.Index, :new

    live "/posts/:post_id/comments/:id/edit", CommentLive.Index, :edit

    live "/posts/:id", PostLive.Show, :show
    live "/posts/:id/show/edit", PostLive.Show, :edit
  end
  
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: TwitterCloneWeb.Telemetry
    end
  end
end
