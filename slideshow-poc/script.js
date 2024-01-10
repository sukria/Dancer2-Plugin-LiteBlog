document.addEventListener("DOMContentLoaded", function() {
    const slides = document.querySelectorAll(".slideshow-element");
    let currentSlideIndex = 0;

    function setupSlides() {
        slides.forEach((slide, index) => {
            if (index !== currentSlideIndex) {
                slide.classList.add('below');
            }
        });
    }

    function changeSlide(nextSlideIndex) {
        if (nextSlideIndex >= 0 && nextSlideIndex < slides.length) {
            
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

                currentSlideIndex = nextSlideIndex;
            }, 500); // Durée de la transition
        }
    }

    setupSlides();

    document.addEventListener("keydown", function(event) {
        if (event.key === 'ArrowDown') {
            changeSlide(currentSlideIndex + 1);
        } else if (event.key === 'ArrowUp') {
            changeSlide(currentSlideIndex - 1);
        }
    });
});

