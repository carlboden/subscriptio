const initUpdateNavbarOnScroll = () => {
  const navbar = document.querySelector('.navbar-lewagon');
  if (navbar) {
    window.addEventListener('scroll', () => {
      if (window.scrollY >= window.innerHeight) {
        navbar.classList.add('navbar-lewagon-white');
      } else {
        navbar.classList.remove('navbar-lewagon-white');
      }
    });
  }

  const navbarhome = document.querySelector('.navbar-home');
  if (navbarhome) {
    window.addEventListener('scroll', () => {
      if (window.scrollY >= window.innerHeight) {
        navbar.classList.remove('navbar-home');
      } else {
        navbar.classList.add('navbar-home');
      }
    });
  }
}

const initActivateNavItem = () => {
  const navitem = document.querySelector('.nav-item');
  console.log(navitem);
    navitem.addEventListener('click', (event) => {

      navitem.classList.add('active');

    })
}



export { initUpdateNavbarOnScroll, initActivateNavItem };
