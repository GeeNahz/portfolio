defmodule Mix.Tasks.Portfolio.CreateAdmin do
  @shortdoc "Creates the admin account for the management portal"

  @moduledoc """
  Creates a confirmed admin user who can log in at `/users/log-in`.

      $ mix portfolio.create_admin you@example.com "a long password"

  Public registration is disabled, so this is the only way to create an account.
  Passwords must be 12–72 characters.
  """
  use Mix.Task

  @requirements ["app.start"]

  @impl Mix.Task
  def run([email, password]) do
    case Portfolio.Accounts.create_admin(email, password) do
      {:ok, user} ->
        Mix.shell().info("Created admin #{user.email}")

      {:error, changeset} ->
        errors =
          Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
            Enum.reduce(opts, msg, fn {key, value}, acc ->
              String.replace(acc, "%{#{key}}", to_string(value))
            end)
          end)

        Mix.raise("Could not create admin: #{inspect(errors)}")
    end
  end

  def run(_args) do
    Mix.raise("Usage: mix portfolio.create_admin EMAIL PASSWORD")
  end
end
