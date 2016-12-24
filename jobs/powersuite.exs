use Kitto.Job.DSL

job :powersuite_stats, every: {1, :hour} do
  stat_data = APIs.Powersuite.stats("filter[stat_type]=power_suite&limit=1")
    |> Map.get("stats")
    |> Enum.at(0)
    |> Map.get("stat")
    |> Map.get("stat_data")
  broadcast! :docket_count, %{value: stat_data["docket_count"]}
  broadcast! :filing_count, %{value: stat_data["filing_count"]}
  broadcast! :document_count, %{value: stat_data["document_count"]}
  broadcast! :bill_count, %{value: stat_data["bill_count"]}
end
