document.addEventListener('DOMContentLoaded', function () {
  document.querySelectorAll('.evaluate').forEach(button => {
    button.addEventListener('click', function () {
      button.closest('form').submit();
    });
  });
});
