#PgSearch.multisearch_options = {
#  :using => [:tsearch, :trigram]
#
#PgSearch.multisearch_options = {
#  using: { tsearch: { any_word: true } }
#}

PgSearch.multisearch_options = {
  using: { tsearch: { prefix: true } }
}