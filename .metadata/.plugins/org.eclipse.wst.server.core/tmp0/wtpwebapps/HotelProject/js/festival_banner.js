let currentSlide = 0;
let data = [];
const wrapper = document.getElementById('sliderWrapper');

fetch('festivals.json')
  .then(res => res.json())
  .then(json => {
    data = json;
    data.forEach(event => {
      const slide = document.createElement('div');
      slide.className = 'slide flex-shrink-0 w-full bg-white text-center';
      slide.innerHTML = `
        <img src="${event.firstimage}" alt="${event.title}" class="w-full h-96 object-cover" />
        <div class="p-5">
          <div class="text-lg font-bold">${event.title}</div>
          <div class="text-gray-600 text-sm">${formatDate(event.eventstartdate)} ~ ${formatDate(event.eventenddate)}</div>
          <div class="text-gray-600 text-sm">${event.addr1}</div>
        </div>
      `;
      wrapper.appendChild(slide);
    });
    updateSlide();
    setInterval(nextSlide, 5000); // 5초마다 자동 슬라이드
  });

function formatDate(dateStr) {
  return `${dateStr.substring(0, 4)}.${dateStr.substring(4, 6)}.${dateStr.substring(6, 8)}`;
}

function updateSlide() {
  wrapper.style.transform = `translateX(-${currentSlide * 100}%)`;
}

function nextSlide() {
  currentSlide = (currentSlide + 1) % data.length;
  updateSlide();
}

function prevSlide() {
  currentSlide = (currentSlide - 1 + data.length) % data.length;
  updateSlide();
}

document.getElementById('nextBtn').addEventListener('click', nextSlide);
document.getElementById('prevBtn').addEventListener('click', prevSlide);