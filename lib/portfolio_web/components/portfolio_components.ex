defmodule PortfolioWeb.PortfolioComponents do
  @moduledoc """
  The sections of the public portfolio page.

  Every section takes its content from `Portfolio.Content.home_page/0`.
  """
  use Phoenix.Component

  alias Phoenix.LiveView.JS

  @section_px "px-4 sm:px-[clamp(16px,5vw,64px)]"

  @doc """
  Renders text with `**double asterisks**` turned into `<strong>`.

  The text is HTML-escaped first, so admin-entered content cannot inject markup.
  """
  attr :text, :string, required: true

  def rich_text(assigns) do
    ~H"{format_rich_text(@text)}"
  end

  @doc false
  def format_rich_text(nil), do: Phoenix.HTML.raw("")

  def format_rich_text(text) do
    text
    |> Phoenix.HTML.html_escape()
    |> Phoenix.HTML.safe_to_string()
    |> String.replace(~r/\*\*(.+?)\*\*/, "<strong>\\1</strong>")
    |> Phoenix.HTML.raw()
  end

  @doc "Zero-padded ordinal for list positions: 0 -> \"01\"."
  def ordinal(index),
    do: index |> Kernel.+(1) |> Integer.to_string() |> String.pad_leading(2, "0")

  @doc "The site navigation with the Light/Dark/System theme switch."
  attr :profile, :map, required: true
  attr :social_links, :list, required: true

  def site_nav(assigns) do
    assigns = assign(assigns, :section_px, @section_px)

    ~H"""
    <header id="site-nav" class={["py-6", @section_px]}>
      <nav
        aria-label="Primary"
        class="mx-auto flex max-w-[1200px] flex-wrap items-baseline justify-between gap-x-8 gap-y-3"
      >
        <a href="#top" class="flex flex-wrap items-baseline gap-x-3.5 gap-y-1">
          <span class="text-[22px] font-extrabold tracking-[-0.02em]">{@profile.name}</span>
          <span class="font-mono text-[13px] text-muted">/ {String.downcase(@profile.role || "")}</span>
        </a>
        <div class="flex flex-wrap items-center gap-x-8 gap-y-3">
          <div class="flex flex-wrap gap-x-6 gap-y-2 font-mono text-sm">
            <a :for={{label, href} <- nav_anchors()} class="lnk" href={href}>{label}</a>
            <a
              :for={link <- Enum.filter(@social_links, & &1.show_in_nav)}
              class="lnk"
              href={link.url}
              rel="me noopener"
            >
              {link.label} ↗
            </a>
          </div>
          <.theme_switch />
        </div>
      </nav>
    </header>
    """
  end

  defp nav_anchors do
    [
      {"Stack", "#stack"},
      {"Systems", "#systems"},
      {"Approach", "#approach"},
      {"Elixir", "#elixir"},
      {"Contact", "#contact"}
    ]
  end

  @doc """
  Three-way theme switch. Uses the `phx:set-theme` listener in the root layout;
  the pressed style comes from `data-theme`/`data-theme-source` on `<html>`.
  """
  def theme_switch(assigns) do
    ~H"""
    <div id="theme-switch" role="group" aria-label="Colour theme" class="flex border-2 border-ink">
      <button
        :for={{theme, label} <- [{"light", "Light"}, {"dark", "Dark"}, {"system", "System"}]}
        type="button"
        class="theme-opt min-h-11 cursor-pointer bg-transparent px-3.5 font-mono text-[13px] text-ink"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme={theme}
      >
        {label}
      </button>
    </div>
    """
  end

  @doc "Section eyebrow, rendered as a `// comment`."
  attr :text, :string, required: true
  attr :class, :any, default: "text-accent-text"
  slot :inner_block

  def eyebrow(assigns) do
    ~H"""
    <p class={["m-0 font-mono text-sm", @class]}>// {@text}{render_slot(@inner_block)}</p>
    """
  end

  @doc "Large section heading."
  attr :class, :any, default: nil
  slot :inner_block, required: true

  def section_heading(assigns) do
    ~H"""
    <h2 class={[
      "m-0 max-w-[900px] text-[clamp(34px,5.2vw,68px)] leading-none font-extrabold tracking-[-0.035em] text-balance",
      @class
    ]}>
      {render_slot(@inner_block)}
    </h2>
    """
  end

  attr :profile, :map, required: true
  attr :stats, :list, required: true

  def hero(assigns) do
    assigns = assign(assigns, :section_px, @section_px)

    ~H"""
    <section id="top" class={["pt-14 pb-24", @section_px]}>
      <div class="mx-auto flex max-w-[1200px] flex-col gap-12">
        <h1 class="m-0 text-[clamp(56px,12.5vw,184px)] leading-[0.9] font-extrabold tracking-[-0.045em]">
          {@profile.headline}<span
            aria-hidden="true"
            class="ml-[0.04em] inline-block size-[0.16em] bg-accent"
          ></span>
        </h1>
        <div class="flex flex-wrap items-start gap-x-16 gap-y-10">
          <p class="m-0 max-w-[700px] flex-[2_1_420px] text-[clamp(20px,2.2vw,26px)] leading-[1.4] text-pretty">
            {@profile.intro}
          </p>
          <div class="flex flex-[1_1_260px] flex-col items-start gap-5">
            <a
              id="hero-cta"
              class="btn-brut inline-flex min-h-[54px] items-center border-2 border-ink bg-accent px-7 font-semibold text-on-accent"
              href={"mailto:#{@profile.email}"}
            >
              {@profile.cta_label} →
            </a>
            <div
              :if={@profile.learning_badge not in [nil, ""]}
              class="inline-block -rotate-3 bg-brand-violet px-4 py-2.5 font-mono text-sm text-white"
            >
              {@profile.learning_badge}
            </div>
          </div>
        </div>
        <div
          id="hero-stats"
          class="flex flex-wrap gap-x-10 gap-y-2 border-t-2 border-ink pt-6 font-mono text-sm"
        >
          <span :for={stat <- @stats} id={"hero-stat-#{stat.id}"}>{stat.label}</span>
        </div>
      </div>
    </section>
    """
  end

  attr :copy, :map, required: true
  attr :layers, :list, required: true
  attr :selected_id, :string, default: nil

  def stack_explorer(assigns) do
    selected =
      Enum.find(assigns.layers, &(&1.id == assigns.selected_id)) || List.first(assigns.layers)

    assigns = assign(assigns, selected: selected, section_px: @section_px)

    ~H"""
    <section
      id="stack"
      class={["border-y-2 border-ink bg-surface py-24", @section_px]}
    >
      <div class="mx-auto flex max-w-[1200px] flex-col gap-12">
        <div class="flex flex-col gap-4">
          <.eyebrow text={@copy.eyebrow} />
          <.section_heading>{@copy.heading}</.section_heading>
          <p :if={@copy.intro} class="m-0 max-w-[640px] text-muted">{@copy.intro}</p>
        </div>

        <div id="stack-tabs" role="group" aria-label="Stack layers" class="flex flex-wrap gap-3">
          <button
            :for={{layer, index} <- Enum.with_index(@layers)}
            id={"layer-tab-#{layer.id}"}
            type="button"
            phx-click="select_layer"
            phx-value-id={layer.id}
            aria-pressed={to_string(@selected && layer.id == @selected.id)}
            class={[
              "layer-tab min-h-12 border-2 px-5 font-mono text-[15px]",
              if(layer.featured, do: "border-dashed border-violet", else: "border-solid border-ink"),
              tab_colors(layer, @selected)
            ]}
          >
            {ordinal(index)} {layer.label}
          </button>
        </div>

        <div class="min-h-[340px]">
          <div
            :if={@selected}
            id={"layer-panel-#{@selected.id}"}
            class="flex flex-wrap gap-x-16 gap-y-8"
          >
            <div class="flex-[1_1_340px]">
              <h3 class={[
                "m-0 text-[clamp(30px,3.6vw,48px)] leading-[1.05] font-extrabold tracking-[-0.03em]",
                @selected.featured && "text-violet"
              ]}>
                {@selected.heading}
              </h3>
              <p class="mt-4 mb-0 text-muted">{@selected.summary}</p>
              <a
                :if={@selected.link_url not in [nil, ""]}
                class="lnk mt-5 inline-block font-mono text-[15px] font-medium"
                href={@selected.link_url}
              >
                {@selected.link_label || @selected.link_url}
              </a>
            </div>
            <ul class="m-0 flex flex-[1_1_380px] list-none flex-col p-0">
              <li
                :for={highlight <- @selected.highlights}
                class={[
                  "border-t-2 py-4 last:border-b-2",
                  if(@selected.featured, do: "border-violet", else: "border-ink")
                ]}
              >
                <.rich_text text={highlight} />
              </li>
            </ul>
          </div>
        </div>
      </div>
    </section>
    """
  end

  defp tab_colors(layer, selected) do
    cond do
      selected && layer.id == selected.id && layer.featured -> "bg-brand-violet text-white"
      selected && layer.id == selected.id -> "bg-ink text-paper"
      true -> "bg-surface text-ink"
    end
  end

  attr :copy, :map, required: true
  attr :projects, :list, required: true

  def systems_ledger(assigns) do
    assigns = assign(assigns, :section_px, @section_px)

    ~H"""
    <section id="systems" class={["py-24", @section_px]}>
      <div class="mx-auto flex max-w-[1200px] flex-col gap-12">
        <div class="flex flex-col gap-4">
          <.eyebrow text={@copy.eyebrow} />
          <.section_heading>{@copy.heading}</.section_heading>
          <p :if={@copy.intro} class="m-0 max-w-[640px] text-muted">{@copy.intro}</p>
        </div>

        <div id="projects" class="border-t-2 border-ink">
          <div
            :for={{project, index} <- Enum.with_index(@projects)}
            id={"project-#{project.id}"}
            class="ledger-row flex flex-wrap gap-x-10 gap-y-3 border-b-2 border-ink px-3 py-7"
          >
            <div class="flex-[0_0_120px] font-mono text-sm">
              {ordinal(index)}<br />{project.years}
            </div>
            <div class="flex-[1_1_240px]">
              <div class="text-[30px] leading-[1.1] font-extrabold tracking-[-0.02em]">
                <%= if project.url not in [nil, ""] do %>
                  <a class="lnk" href={project.url} rel="noopener">{project.name} ↗</a>
                <% else %>
                  {project.name}
                <% end %>
              </div>
              <div class="mt-1 font-mono text-[13px]">{project.category}</div>
            </div>
            <div class="flex-[2_1_320px]"><.rich_text text={project.summary} /></div>
            <div class="flex-[1_1_220px] font-semibold"><.rich_text text={project.outcome} /></div>
          </div>
        </div>
      </div>
    </section>
    """
  end

  attr :copy, :map, required: true
  attr :principles, :list, required: true

  def approach(assigns) do
    assigns = assign(assigns, :section_px, @section_px)

    ~H"""
    <section
      id="approach"
      class={["border-y-2 border-ink bg-accent py-24 text-on-accent", @section_px]}
    >
      <div class="mx-auto flex max-w-[1200px] flex-col gap-14">
        <div class="flex flex-col gap-4">
          <.eyebrow text={@copy.eyebrow} class={nil} />
          <.section_heading>{@copy.heading}</.section_heading>
          <p :if={@copy.intro} class="m-0 max-w-[640px]">{@copy.intro}</p>
        </div>
        <div class="grid grid-cols-[repeat(auto-fit,minmax(min(480px,100%),1fr))] gap-x-16 gap-y-12">
          <div
            :for={{principle, index} <- Enum.with_index(@principles)}
            id={"principle-#{principle.id}"}
            class="border-t-[3px] border-on-accent pt-5"
          >
            <div class="font-mono text-sm">{ordinal(index)}</div>
            <h3 class="mt-2 mb-3 text-[32px] leading-[1.1] font-extrabold tracking-[-0.02em]">
              {principle.title}
            </h3>
            <p class="m-0"><.rich_text text={principle.body} /></p>
          </div>
        </div>
      </div>
    </section>
    """
  end

  attr :copy, :map, required: true
  attr :topics, :list, required: true
  attr :profile, :map, required: true

  def elixir_section(assigns) do
    assigns = assign(assigns, :section_px, @section_px)

    ~H"""
    <section id="elixir" class={["bg-elx-bg py-24 text-elx-fg", @section_px]}>
      <div class="mx-auto flex max-w-[1200px] flex-col gap-14">
        <div class="flex flex-col gap-4">
          <.eyebrow text={@copy.eyebrow} class="text-lilac">
            <span
              aria-hidden="true"
              class="cursor-blink ml-1.5 inline-block h-4 w-[9px] bg-lilac align-[-2px]"
            ></span>
          </.eyebrow>
          <.section_heading>{@copy.heading}</.section_heading>
          <p :if={@copy.intro} class="m-0 max-w-[680px] text-xl text-elx-muted">{@copy.intro}</p>
        </div>

        <div class="flex flex-wrap gap-12">
          <div class="flex min-w-0 flex-[1_1_380px] flex-col gap-7">
            <div
              :for={topic <- @topics}
              id={"topic-#{topic.id}"}
              class="border-t-2 border-brand-violet pt-5"
            >
              <h3 class="mt-0 mb-1.5 text-[26px] font-extrabold tracking-[-0.02em]">
                {topic.title}
              </h3>
              <p class="m-0 text-elx-muted"><.rich_text text={topic.body} /></p>
            </div>
            <a
              :if={@profile.learning_link_url not in [nil, ""]}
              id="learning-link"
              class="lnk self-start font-mono text-[15px] text-lilac"
              href={@profile.learning_link_url}
            >
              {@profile.learning_link_label || @profile.learning_link_url} ↗
            </a>
          </div>

          <div class="flex min-w-0 flex-[1_1_440px] flex-col gap-5">
            <figure class="m-0 border-2 border-brand-violet">
              <figcaption class="bg-brand-violet px-[18px] py-2.5 font-mono text-[13px] text-white">
                iex&gt; pipes.ex
              </figcaption>
              <pre
                phx-no-curly-interpolation
                class="m-0 overflow-x-auto p-5 font-mono text-sm leading-[1.7]"
              ><span class="text-code-comment"># a pipeline, the Elixir way</span>
    <span class="text-code-string">"<%= String.downcase(@profile.name || "") %>"</span>
    <span class="text-lilac">|&gt;</span> String.split()
    <span class="text-lilac">|&gt;</span> Enum.map(<span class="text-lilac">&amp;</span>String.capitalize/1)
    <span class="text-lilac">|&gt;</span> Enum.join(<span class="text-code-string">" "</span>)
    <span class="text-code-comment"># =&gt; "<%= @profile.name %>"</span></pre>
            </figure>
            <figure class="m-0 border-2 border-brand-violet">
              <figcaption class="bg-brand-violet px-[18px] py-2.5 font-mono text-[13px] text-white">
                live_view.ex
              </figcaption>
              <pre
                phx-no-curly-interpolation
                class="m-0 overflow-x-auto p-5 font-mono text-sm leading-[1.7]"
              ><span class="text-lilac">def</span> handle_event(<span class="text-code-string">"save"</span>, %{<span class="text-code-string">"note"</span> =&gt; note}, socket) <span class="text-lilac">do</span>
      {<span class="text-code-atom">:noreply</span>, assign(socket, <span class="text-code-atom">:saved</span>, note)}
    <span class="text-lilac">end</span></pre>
            </figure>
          </div>
        </div>
      </div>
    </section>
    """
  end

  attr :credentials, :list, required: true

  def credentials_strip(assigns) do
    assigns = assign(assigns, :section_px, @section_px)

    ~H"""
    <section id="credentials" class={["py-[72px]", @section_px]}>
      <div class="mx-auto grid max-w-[1200px] grid-cols-[repeat(auto-fit,minmax(min(240px,100%),1fr))] gap-8">
        <div
          :for={credential <- @credentials}
          id={"credential-#{credential.id}"}
          class="border-t-2 border-ink pt-4"
        >
          <div class="font-mono text-[13px] text-muted">{credential.kind}</div>
          <p class="mt-1.5 mb-0"><.rich_text text={credential.body} /></p>
        </div>
      </div>
    </section>
    """
  end

  attr :copy, :map, required: true
  attr :profile, :map, required: true
  attr :social_links, :list, required: true

  def contact(assigns) do
    assigns = assign(assigns, :section_px, @section_px)

    ~H"""
    <section id="contact" class={["border-t-2 border-ink pt-24 pb-14", @section_px]}>
      <div class="mx-auto flex max-w-[1200px] flex-col gap-10">
        <.eyebrow text={@copy.eyebrow} />
        <h2 class="m-0 text-[clamp(40px,8vw,120px)] leading-[0.95] font-extrabold tracking-[-0.04em] text-balance">
          {@copy.heading}
        </h2>
        <p :if={@copy.intro} class="m-0 max-w-[640px] text-muted">{@copy.intro}</p>
        <div class="flex flex-wrap items-center gap-x-8 gap-y-5">
          <a
            id="contact-email"
            class="btn-brut inline-flex min-h-[58px] items-center border-2 border-ink bg-accent px-8 text-xl font-semibold text-on-accent"
            href={"mailto:#{@profile.email}"}
          >
            {@profile.email} →
          </a>
          <a
            :for={link <- Enum.filter(@social_links, & &1.show_in_contact)}
            id={"contact-link-#{link.id}"}
            class="lnk font-mono text-[15px]"
            href={link.url}
            rel="me noopener"
          >
            {link.display_text} ↗
          </a>
        </div>
        <footer class="mt-12 flex flex-wrap justify-between gap-x-6 gap-y-2 border-t-2 border-ink pt-5 font-mono text-[13px]">
          <span>© {Date.utc_today().year} {@profile.name}</span>
          <span>{@profile.location}</span>
        </footer>
      </div>
    </section>
    """
  end
end
