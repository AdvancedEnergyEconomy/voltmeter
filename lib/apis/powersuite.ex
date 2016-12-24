defmodule APIs.Powersuite do
  def stats(filter) do
    filter = URI.encode "&#{filter}"
    url = URI.parse url <> base_url <> filter
    request(url)
  end

  def stats do
    url = URI.parse url <> base_url
    request(url)
  end

  def state_stats(powersuite_stat_data) do
    %{items: powersuite_stat_data["current_bill_count_by_state"] |> Enum.map(&APIs.Powersuite.state_stat_for_dashboard/1)}
  end

  def state_stat_for_dashboard(state_stat) do
    %{label: Enum.at(state_stat, 0), value: Enum.at(state_stat, 1)}
  end

  defp request(url) do
    case HTTPoison.get(url) do
      {:ok,  %HTTPoison.Response{status_code: 200, body: body}} ->
        Poison.decode!(body)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:ok, %HTTPoison.Response{status_code: 401}} ->
        IO.puts "Bad Token :("
      {:ok, _} ->
        IO.puts "Unrecognized response:("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  defp token, do: Application.get_env(:voltmeter, :powersuite_token)
  defp url, do: Application.get_env(:voltmeter, :powersuite_url)
  defp base_url, do: "/api/v1/stats?token=#{token}"
end
