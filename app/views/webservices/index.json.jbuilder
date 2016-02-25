json.array!(@webservices) do |webservice|
  json.extract! webservice, :id
  json.url webservice_url(webservice, format: :json)
end
