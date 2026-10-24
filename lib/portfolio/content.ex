defmodule Portfolio.Content do
  @moduledoc """
  The editable content of the public portfolio.

  Ordered collections (`HeroStat`, `SocialLink`, `StackLayer`, `Project`,
  `Principle`, `LearningTopic`, `Credential`) share one generic API that takes
  the schema module as its first argument. `Profile` is a singleton and
  `SectionCopy` rows are fixed per section key.
  """
  import Ecto.Query, warn: false

  alias Portfolio.Repo

  alias Portfolio.Content.{
    Credential,
    HeroStat,
    LearningTopic,
    Principle,
    Profile,
    Project,
    SectionCopy,
    SocialLink,
    StackLayer
  }

  @collections [HeroStat, SocialLink, StackLayer, Project, Principle, LearningTopic, Credential]

  @doc "The schema modules managed through the ordered-collection API."
  def collections, do: @collections

  defguardp is_collection(schema) when schema in @collections

  ## Ordered collections

  @doc "Lists a collection in display order."
  def list(schema) when is_collection(schema) do
    schema |> ordered() |> Repo.all()
  end

  @doc "Counts the rows in a collection."
  def count(schema) when is_collection(schema), do: Repo.aggregate(schema, :count)

  @doc "Gets one row of a collection. Raises if it does not exist."
  def get!(schema, id) when is_collection(schema), do: Repo.get!(schema, id)

  @doc "Returns a changeset for tracking changes to a collection row."
  def change(%schema{} = struct, attrs \\ %{}) when is_collection(schema) do
    schema.changeset(struct, attrs)
  end

  @doc "Creates a row at the end of the collection."
  def create(schema, attrs) when is_collection(schema) do
    schema
    |> struct(position: next_position(schema))
    |> schema.changeset(attrs)
    |> Repo.insert()
  end

  @doc "Updates a collection row."
  def update(%schema{} = struct, attrs) when is_collection(schema) do
    struct
    |> schema.changeset(attrs)
    |> Repo.update()
  end

  @doc "Deletes a collection row."
  def delete(%schema{} = struct) when is_collection(schema), do: Repo.delete(struct)

  @doc """
  Swaps a row with its neighbour above (`:up`) or below (`:down`).

  Returns `{:ok, :unchanged}` when the row is already at that end.
  """
  def move(%schema{} = struct, direction)
      when is_collection(schema) and direction in [:up, :down] do
    rows = list(schema)
    index = Enum.find_index(rows, &(&1.id == struct.id))
    neighbour_index = if direction == :up, do: index - 1, else: index + 1

    if neighbour_index < 0 or neighbour_index >= length(rows) do
      {:ok, :unchanged}
    else
      rows
      |> List.update_at(index, fn _ -> Enum.at(rows, neighbour_index) end)
      |> List.update_at(neighbour_index, fn _ -> Enum.at(rows, index) end)
      |> renumber()
    end
  end

  defp renumber(rows) do
    Repo.transact(fn ->
      rows
      |> Enum.with_index()
      |> Enum.each(fn {row, position} ->
        if row.position != position do
          row |> Ecto.Changeset.change(position: position) |> Repo.update!()
        end
      end)

      {:ok, :moved}
    end)
  end

  defp ordered(queryable), do: order_by(queryable, [r], asc: r.position, asc: r.inserted_at)

  defp next_position(schema) do
    case Repo.one(from r in schema, select: max(r.position)) do
      nil -> 0
      max -> max + 1
    end
  end

  ## Profile

  @doc """
  Returns the profile, or an empty unsaved one if none has been created yet.
  """
  def get_profile do
    Repo.one(from p in Profile, limit: 1) || %Profile{}
  end

  @doc "Returns a changeset for tracking profile changes."
  def change_profile(%Profile{} = profile, attrs \\ %{}), do: Profile.changeset(profile, attrs)

  @doc "Creates the profile on first save, updates it afterwards."
  def save_profile(%Profile{} = profile, attrs) do
    profile
    |> Profile.changeset(attrs)
    |> Repo.insert_or_update()
  end

  ## Section copy

  @doc "Returns all section copy as a map keyed by section key."
  def section_copies do
    SectionCopy |> Repo.all() |> Map.new(&{&1.key, &1})
  end

  @doc "Lists section copy in page order."
  def list_section_copies do
    copies = section_copies()

    SectionCopy.keys()
    |> Enum.map(&Map.get(copies, &1))
    |> Enum.reject(&is_nil/1)
  end

  @doc "Gets one section's copy by id. Raises if it does not exist."
  def get_section_copy!(id), do: Repo.get!(SectionCopy, id)

  @doc "Returns a changeset for tracking section copy changes."
  def change_section_copy(%SectionCopy{} = copy, attrs \\ %{}),
    do: SectionCopy.changeset(copy, attrs)

  @doc "Updates a section's copy."
  def update_section_copy(%SectionCopy{} = copy, attrs) do
    copy
    |> SectionCopy.changeset(attrs)
    |> Repo.update()
  end

  @doc "Creates or replaces the copy for a section key. Used by the seeds."
  def upsert_section_copy(attrs) do
    %SectionCopy{}
    |> SectionCopy.create_changeset(attrs)
    |> Repo.insert(
      on_conflict: {:replace, [:eyebrow, :heading, :intro, :updated_at]},
      conflict_target: :key,
      returning: true
    )
  end

  ## Public page

  @doc """
  Loads everything the public home page renders.
  """
  def home_page do
    %{
      profile: get_profile(),
      hero_stats: list(HeroStat),
      social_links: list(SocialLink),
      stack_layers: list(StackLayer),
      projects: list(Project),
      principles: list(Principle),
      learning_topics: list(LearningTopic),
      credentials: list(Credential),
      sections: section_copies()
    }
  end
end
