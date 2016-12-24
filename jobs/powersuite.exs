use Kitto.Job.DSL

job :powersuite_stats, every: {30, :seconds} do
  stats = APIs.Powersuite.stats("filter[stat_type]=power_suite&limit=1")
  [stat | _] = stats["stats"]
  stat_data = stat["stat"]["stat_data"]
  bill_state_counts = APIs.Powersuite.state_stats(stat_data)
  dockets_count = stat_data["docket_count"]

  broadcast! :bill_state_counts, bill_state_counts
  broadcast! :dockets_count, %{value: dockets_count}
end
