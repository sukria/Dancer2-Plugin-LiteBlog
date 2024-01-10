document.addEventListener("DOMContentLoaded", function() {
    const slides = document.querySelectorAll(".slideshow-element");
    let currentSlideIndex = 0;
    let isScrolling = false;

    // should be greater than 400 because the CSS effect is set to 400 ms.
    let scrollDelay = 410;
    let shakeDelay = 300;

    function setupSlides() {
        slides.forEach((slide, index) => {
            if (index !== currentSlideIndex) {
                slide.classList.add('below');
            }
        });
    }

    function applyShakeEffect() {
        slides[currentSlideIndex].classList.add('shake');
        setTimeout(() => {
            slides[currentSlideIndex].classList.remove('shake');
        }, shakeDelay);
    }

    function changeSlide(nextSlideIndex) {
        if (!isScrolling && nextSlideIndex >= 0 && nextSlideIndex < slides.length) {
            isScrolling = true;

            // Next slide takes the lead
            slides[nextSlideIndex].classList.add('active');

            // down
            if (currentSlideIndex < nextSlideIndex) {
                slides[currentSlideIndex].classList.add('above');
                slides[nextSlideIndex].classList.remove('below');
            }
            //up
            else {
                slides[currentSlideIndex].classList.add('below');
                slides[nextSlideIndex].classList.remove('above');
            }

            setTimeout(() => {
                slides[currentSlideIndex].classList.remove('active');

                // going up...
                if (nextSlideIndex < currentSlideIndex) {
                    slides[currentSlideIndex].classList.remove('above');
                    slides[currentSlideIndex].classList.add('below');
                }
                // going down
                else {
                    slides[currentSlideIndex].classList.remove('below');
                    slides[currentSlideIndex].classList.add('above');
                }

                setTimeout(() => {
                    isScrolling = false;
                }, 800); 

                currentSlideIndex = nextSlideIndex;
            }, scrollDelay); 
        }

        // at the first or the last slide
        else if (!isScrolling) {
            applyShakeEffect();
        }
    }

    setupSlides();

    // Handle key strokes
    document.addEventListener("keydown", function(event) {
        if (event.key === 'ArrowDown') {
            changeSlide(currentSlideIndex + 1);
        } else if (event.key === 'ArrowUp') {
            changeSlide(currentSlideIndex - 1);
        }
    });

    // Handle wheel scroll
    document.addEventListener("wheel", function(event) {
        if (event.deltaY > 0) {
            changeSlide(currentSlideIndex + 1);
        } else if (event.deltaY < 0) {
            changeSlide(currentSlideIndex - 1);
        }
    });
});

