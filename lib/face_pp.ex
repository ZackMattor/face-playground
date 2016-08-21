defmodule FacePP do
  use HTTPoison.Base

  @api_key System.get_env("FACEPP_API_KEY")
  @api_secret System.get_env("FACEPP_API_SECRET")

  # test-face: http://www.rantlifestyle.com/wp-content/uploads/2014/03/1.-Ryan-Gosling.jpg
  def detect(url) do
    FacePP.start
    FacePP.get!("/detection/detect?api_key=#{@api_key}&api_secret=#{@api_secret}&url=#{url}").body
  end

  @expected_fields ~w(
    error error_code face img_height img_id img_width session_id url
  )

  def process_url(url) do
    "https://apius.faceplusplus.com" <> url
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
    |> Map.take(@expected_fields)
    |> Enum.map(fn({k, v}) -> {String.to_atom(k), v} end)
  end
end
