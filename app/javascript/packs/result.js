document.addEventListener('turbolinks:load', function() {
  function getLocationAndSortByDistance() {
    navigator.geolocation.getCurrentPosition(function(position) {
      const lat = position.coords.latitude;
      const lng = position.coords.longitude;

      const query = new URLSearchParams(window.location.search);
      query.set('lat', lat);
      query.set('lng', lng);
      query.set('sort', 'distance');

      const url = `/result?${query.toString()}`;

      window.location.href = url;
    }, function(error) {
      console.error("位置情報の取得に失敗しました: ", error);
    });
  }

  const sortLink = document.getElementById('sort-by-distance');
  if (sortLink) {
    sortLink.addEventListener('click', function(event) {
      event.preventDefault();
      getLocationAndSortByDistance();
    });
  }

  const priceSortByGramLink = document.getElementById('sort-by-gram');
  if (priceSortByGramLink) {
    priceSortByGramLink.addEventListener('click', function(event) {
      event.preventDefault();

      const query = new URLSearchParams(window.location.search);
      
      query.set('sort', 'gram');

      window.location.href = `/result?${query.toString()}`;
    });
  }

  const priceSortByQuantityLink = document.getElementById('sort-by-quantity');
  if (priceSortByQuantityLink) {
    priceSortByQuantityLink.addEventListener('click', function(event) {
      event.preventDefault();

      const query = new URLSearchParams(window.location.search);
      
      query.set('sort', 'quantity');

      window.location.href = `/result?${query.toString()}`;
    });
  }
});
