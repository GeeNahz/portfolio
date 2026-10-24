defmodule Portfolio.Content.Validators do
  @moduledoc """
  Changeset validations shared by the content schemas.
  """
  import Ecto.Changeset

  @doc """
  Accepts absolute http(s) URLs, `mailto:` links and in-page anchors (`#contact`).
  """
  def validate_url(changeset, field) do
    validate_change(changeset, field, fn ^field, value ->
      if valid_url?(value), do: [], else: [{field, "must be an http(s), mailto: or #anchor link"}]
    end)
  end

  defp valid_url?("#" <> anchor), do: anchor != ""
  defp valid_url?("mailto:" <> address), do: String.contains?(address, "@")

  defp valid_url?(value) do
    case URI.parse(value) do
      %URI{scheme: scheme, host: host} when scheme in ["http", "https"] and is_binary(host) ->
        host != ""

      _ ->
        false
    end
  end
end
