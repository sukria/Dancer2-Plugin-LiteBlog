document.addEventListener("DOMContentLoaded", function() {
    const slides = document.querySelectorAll(".slideshow-element");
    let currentSlide = 0;
    let isAnimating = false;
    let lastScrollTime = 0;
    const scrollDelay = 1200; // Augmentation du délai pour éviter le défilement rapide

    function changeSlide(newSlide) {
        if (newSlide >= 0 && newSlide < slides.length && !isAnimating) {
            isAnimating = true;
            slides[newSlide].classList.add('active');
            slides[currentSlide].classList.add('previous');

            setTimeout(() => {
                slides[currentSlide].classList.remove('active');
                slides[currentSlide].classList.remove('previous');
                currentSlide = newSlide;
                isAnimating = false;
            }, 700); // Durée légèrement plus longue pour permettre une transition complète
        }
    }

    function applyShakeEffect() {
        slides[currentSlide].classList.add('shake');
        setTimeout(() => {
            slides[currentSlide].classList.remove('shake');
        }, 500);
    }

    window.addEventListener("wheel", function(event) {
        const now = new Date().getTime();
        if (now - lastScrollTime < scrollDelay) {
            return;
        }
        lastScrollTime = now;

        if (event.deltaY > 0) {
            if (currentSlide < slides.length - 1) {
                changeSlide(currentSlide + 1);
            } else {
                applyShakeEffect();
            }
        } else {
            if (currentSlide > 0) {
                changeSlide(currentSlide - 1);
            } else {
                applyShakeEffect();
            }
        }
    });
});

