document.addEventListener('DOMContentLoaded', function() {
  const searchQuery = new URLSearchParams(window.location.search).get('search');
  const messageContainer = document.getElementById('no-products-message');

  if (searchQuery) {
    const lowerCaseQuery = searchQuery.toLowerCase();

    const products = document.querySelectorAll('.each_item');
    let found = false;

    products.forEach(product => {
      const tdElement = product.querySelector('td');
      
      if (tdElement) {
        const productName = tdElement.textContent.toLowerCase();
        
        if (productName.includes(lowerCaseQuery)) {
          product.scrollIntoView({ behavior: 'smooth', block: 'center' });

          product.classList.add('highlight');

          found = true;
          return;
        } else {
          product.classList.remove('highlight');
        }
      } else {
        console.warn('No <td> element found in:', product);
      }
    });

    if (!found) {
      if (messageContainer) {
        messageContainer.textContent = '該当の商品は存在しません。';
        messageContainer.style.display = 'block';
      }
    } else {
      if (messageContainer) {
        messageContainer.style.display = 'none';
      }
    }
  }
});
