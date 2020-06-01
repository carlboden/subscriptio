json.array! (@pg_search_documents) do |soft|
  json.id soft.searchable.id
  json.name soft.searchable.name
end