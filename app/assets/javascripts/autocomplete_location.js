document.addEventListener("DOMContentLoaded", function(event) {
  var locationSearch = function(query, syncResults, asyncResults) {
    $.get('/locations.json', {query: query}, function(data){
      asyncResults(data);
    }, 'json');
  };

  $("input#user_location").typeahead({
    minLength: 1,
    hint: false,
    highlight: true,
  },
  {
    name: "location-search-results",
    source: locationSearch,
    display: function(location) {
      return location.display_name
    },
  });

  // location selected, let's set hidden location_id field
  $("input#user_location").bind("typeahead:select", function(ev, location) {
    // Set hidden form field of location_id
    $("input#user_location_id").val(location.id);
  });
});