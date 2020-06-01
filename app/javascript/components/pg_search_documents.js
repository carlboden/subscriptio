var app = window.app = {};

app.pg_search_documents = function() {
  this._input = $('#term');
  this._initAutocomplete();
};

app.pg_search_documents.prototype = {
  _initAutocomplete: function() {
    this._input
      .autocomplete({
        source: '/softwares',
        appendTo: '#search-results',
        select: $.proxy(this._select, this)
      })
      .autocomplete('instance')._renderItem = $.proxy(this._render, this);
  },

  _render: function(ul, item) {
    var markup = [
      '<span class="title"><a href="' + item.url + '">' + item.title + '</a></span>',
    ];
    return $('<li>')
      .append(markup.join(''))
      .appendTo(ul);
  },

  _select: function(e, ui) {
    this._input.val(ui.item.title);
    return false;
  }
    };