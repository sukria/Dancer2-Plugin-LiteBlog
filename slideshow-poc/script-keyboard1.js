document.addEventListener("DOMContentLoaded", function() {
    const slides = document.querySelectorAll(".slideshow-element");
    let currentSlideIndex = 0;

    function changeSlide(nextSlideIndex) {
        if (nextSlideIndex >= 0 && nextSlideIndex < slides.length) {
            slides[currentSlideIndex].classList.remove('active');
            slides[nextSlideIndex].classList.add('active');
            currentSlideIndex = nextSlideIndex;
        }
    }

    document.addEventListener("keydown", function(event) {
        if (event.key === 'ArrowDown') {
            changeSlide(currentSlideIndex + 1);
        } else if (event.key === 'ArrowUp') {
            changeSlide(currentSlideIndex - 1);
        }
    });
});

