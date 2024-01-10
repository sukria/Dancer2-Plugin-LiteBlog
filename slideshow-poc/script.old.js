document.addEventListener("DOMContentLoaded", function() {
    const slides = document.querySelectorAll(".slideshow-element");
    let currentSlide = 0;
    let isAnimating = false;
    let lastScrollTime = 0;
    const scrollDelay = 800; // Délai entre les scrolls autorisés

    function changeSlide(newSlide) {
        if (newSlide >= 0 && newSlide < slides.length && !isAnimating) {
            isAnimating = true;
            slides[currentSlide].classList.add('previous');
            slides[newSlide].classList.add('active');

            setTimeout(() => {
                slides[currentSlide].classList.remove('active', 'previous');
                currentSlide = newSlide;
                isAnimating = false;
            }, 500); // Correspond à la durée de transition CSS
        }
    }

    function applyShakeEffect() {
        slides[currentSlide].classList.add('shake');
        setTimeout(() => {
            slides[currentSlide].classList.remove('shake');
        }, 500); // Durée de l'animation shake
    }

    window.addEventListener("wheel", function(event) {
        const now = new Date().getTime();
        if (now - lastScrollTime < scrollDelay) {
            return; // Ignorer le scroll si le dernier scroll est trop récent
        }
        lastScrollTime = now;

        if (event.deltaY > 0) {
            if (currentSlide < slides.length - 1) {
                // Défilement vers le bas
                changeSlide(currentSlide + 1);
            } else {
                // Dernier slide, appliquer l'effet de vibration
                applyShakeEffect();
            }
        } else {
            // Défilement vers le haut
            changeSlide(currentSlide - 1);
        }
    });
});

