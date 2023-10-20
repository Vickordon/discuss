defmodule DiscussWeb.Router do
  alias DiscussWeb.AuthController
  alias DiscussWeb.TopicController
  use DiscussWeb, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {DiscussWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug DiscussWeb.Plugs.SetUser # Плаг добавляє юзера в конекшен, після чого ми можемо бачити який юзер робить дії на сайті.
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
  end

  scope "/" do
    pipe_through :browser

    # get "/", TopicController, :index
    # get "/topics/new", TopicController, :new
    # post "/topics", TopicController, :create
    # get "/topics/:id/edit", TopicController, :edit
    # put "/topics/:id", TopicController, :update
    # Якщо потрібні всі рестфул роути, можна використовувати
    resources "/" , TopicController
  end

  scope "/auth" do
    pipe_through :browser
# :provider вказує, що потрібно взяти дані з налаштуваннь і використовувати вказану стратегію.
# providers: [
#   github: {Ueberauth.Strategy.Github, []}
# ]
# Функція request береться з plug Ueberauth
    get "/signout", AuthController, :signout #має бути перед використанням :provider
    get "/:provider", AuthController, :request # формує роут /auth/github
    get "/:provider/callback", AuthController, :callback # формує роут /auth/github/callback

  end
  # Other scopes may use custom stacks.
  # scope "/api", DiscussWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DiscussWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
