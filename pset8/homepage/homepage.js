document.addEventListener('DOMContentLoaded', function(){

    const button = document.querySelector('#menu');
    const menu = document.querySelector('#nav-menu');

    let isOpen = false;

    button.addEventListener('click', function(){
        isOpen = !isOpen

        if (isOpen)
        {
            menu.classList.remove('d-none');
            button.textContent = 'Close';
        }
        else
        {
            menu.classList.add('d-none');
            button.textContent = 'Menu';
        }
    });
});
