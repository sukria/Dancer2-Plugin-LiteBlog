document.addEventListener("DOMContentLoaded", function() {
    const slides = document.querySelectorAll(".slideshow-element");
    let currentSlide = 0;
    let isScrolling = false;
    let lastScrollTime = 0;
    const scrollDelay = 800; // Augmentez le délai pour éviter les déclenchements répétitifs

    function changeSlide(newSlide) {
        if (newSlide >= 0 && newSlide < slides.length && !isScrolling) {
            isScrolling = true;
            slides[newSlide].classList.add('active');
            slides[currentSlide].style.display = '';

            if (currentSlide !== newSlide) {
                slides[currentSlide].classList.add('previous');
            }

            setTimeout(() => {
                slides[currentSlide].classList.remove('active');
                slides[currentSlide].style.display = 'none'; 

                currentSlide = newSlide;

                setTimeout(() => {
                    slides[currentSlide].style.display = '';
                    isScrolling = false;
                }, scrollDelay); 
            }, 500); // Durée de la transition

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

