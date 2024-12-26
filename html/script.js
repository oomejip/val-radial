let isMenuOpen = false;
let keybindConfig = 'F1';

window.addEventListener('message', function(event) {
    const data = event.data;
    if (data.action === 'updateMenuItems') {
        updateMenuItems(data.items);
        document.getElementById('circle-menu').style.display = 'flex';
        isMenuOpen = true;
    } else if (data.action === 'closeMenu') {
        closeMenu();
        
    }
});

document.addEventListener('keydown', function(e) {
    if (e.key === keybindConfig && !isMenuOpen) {
        fetch(`https://${GetParentResourceName()}/togglemenu`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            }
        });
        isMenuOpen = true;
    }
});

document.addEventListener('keyup', function(e) {
    if (e.key === keybindConfig && isMenuOpen) {
        setTimeout(() => {
            fetch(`https://${GetParentResourceName()}/closemenu`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                }
            });
            isMenuOpen = false;
        }, 50);
    }
});

const updateMenuItems = (itemsData) => {
    const menuItemsContainer = document.getElementById('menu-items-container');
    
    const items = menuItemsContainer.querySelectorAll('.menu-item-wrapper');
    items.forEach(item => {
        item.style.transition = 'opacity 0.02s ease-out';
        item.style.opacity = '0';
    });

    setTimeout(() => {
        menuItemsContainer.innerHTML = '';

        itemsData.forEach(itemData => {
            const itemWrapper = document.createElement('div');
            itemWrapper.classList.add('menu-item-wrapper');

            const menuItem = document.createElement('div');
            menuItem.classList.add('menu-item');
            menuItem.setAttribute('data-label', itemData.label);
            menuItem.innerHTML = `<i class="${itemData.icon}"></i>`;

            itemWrapper.appendChild(menuItem);
            menuItemsContainer.appendChild(itemWrapper);
        });

        const updatedItems = document.querySelectorAll('.menu-item-wrapper');
        const itemCount = updatedItems.length;
        const angleIncrement = 360 / itemCount;

        updatedItems.forEach((item, index) => {
            const angle = angleIncrement * index;
            const radians = angle * (Math.PI / 180);
            const translateX = 240 * Math.cos(radians);
            const translateY = 240 * Math.sin(radians);

            item.style.setProperty('--translate-x', `${translateX}px`);
            item.style.setProperty('--translate-y', `${translateY}px`);

            item.style.transition = 'opacity 0.02s ease-in';
            item.style.opacity = '1';
        });

        addHoverListeners();
        addClickListeners();
    }, 200);
};


const setCentralText = (text) => {
    const centralText = document.getElementById('central-text');
    centralText.textContent = text;
    if (text === '') {
        centralText.classList.add('hidden');
    } else {
        centralText.classList.remove('hidden');
    }
};

const addHoverListeners = () => {
    const items = document.querySelectorAll('.menu-item');
    items.forEach(item => {
        item.addEventListener('mouseenter', () => {
            const label = item.getAttribute('data-label');
            setCentralText(label);
        });
        item.addEventListener('mouseleave', () => {
            setCentralText('');
        });
    });
};

const addClickListeners = () => {
    const items = document.querySelectorAll('.menu-item');
    items.forEach(item => {
        item.addEventListener('click', () => {
            const label = item.getAttribute('data-label');
            fetch(`https://${GetParentResourceName()}/menuItemClicked`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({
                    label: label
                })
            }).then(resp => resp.json()).then(resp => {
                if (resp.status === 'success') {
                    const newMenuItems = resp.items;
                    updateMenuItems(newMenuItems);
                }
            });
        });
    });
};

function closeMenu() {
    const menu = document.getElementById('circle-menu');
    const menuItems = document.querySelectorAll('.menu-item-wrapper');

    menuItems.forEach(item => {
        item.style.animation = 'retract 0.1s ease-out forwards';
    });

    // menu.style.transition = 'opacity 0.01s ease-out';
    // menu.style.opacity = '1';

    setTimeout(() => {
        menu.style.display = 'none';
        isMenuOpen = false;
    }, 100);
}
