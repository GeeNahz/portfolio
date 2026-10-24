defmodule PortfolioWeb.PortfolioComponentsTest do
  use ExUnit.Case, async: true

  alias PortfolioWeb.PortfolioComponents

  defp render_rich(text) do
    text |> PortfolioComponents.format_rich_text() |> Phoenix.HTML.safe_to_string()
  end

  describe "format_rich_text/1" do
    test "turns **double asterisks** into <strong>" do
      assert render_rich("down **80%** fast") == "down <strong>80%</strong> fast"
    end

    test "escapes HTML before formatting" do
      assert render_rich("<script>x</script> **<b>y</b>**") ==
               "&lt;script&gt;x&lt;/script&gt; <strong>&lt;b&gt;y&lt;/b&gt;</strong>"
    end

    test "leaves unmatched asterisks alone and handles nil" do
      assert render_rich("2 ** 3") == "2 ** 3"
      assert render_rich(nil) == ""
    end
  end

  test "ordinal/1 zero-pads list positions" do
    assert PortfolioComponents.ordinal(0) == "01"
    assert PortfolioComponents.ordinal(11) == "12"
  end
end
