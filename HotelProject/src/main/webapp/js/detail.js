const stars = document.querySelectorAll('#star-rating .star');
const ratingInput = document.getElementById('rating');
let selectedRating = 0;

stars.forEach(star => {
  star.addEventListener('click', () => {
    selectedRating = parseInt(star.dataset.value);
    ratingInput.value = selectedRating;
    stars.forEach(s => {
      const val = parseInt(s.dataset.value);
      s.classList.toggle('text-yellow-400', val <= selectedRating);
      s.classList.toggle('text-gray-400', val > selectedRating);
    });
  });
});

const form = document.getElementById('review-form');
const reviewList = document.getElementById('review-list');
const avgRatingContainer = document.getElementById('average-rating');

function formatStars(score) {
  return '★★★★★☆☆☆☆☆'.slice(5 - score, 10 - score);
}

function calculateAverageRating(reviews) {
  const total = reviews.reduce((sum, r) => sum + r.rating, 0);
  return (reviews.length ? (total / reviews.length).toFixed(1) : '0.0');
}

function updateAverageRatingDisplay(reviews) {
  const avg = parseFloat(calculateAverageRating(reviews));
  const starCount = Math.round(avg);
  avgRatingContainer.innerHTML = `
    <span class="text-yellow-500 text-2xl mr-2">${formatStars(starCount)}</span>
    <span class="text-gray-700 font-semibold text-lg">${avg} / 5.0</span>
    <span class="text-sm text-gray-500 ml-2">(총 ${reviews.length}개 리뷰)</span>
  `;
}

function displayReviews(reviews) {
  reviewList.innerHTML = '';
  reviews.forEach(r => {
    const div = document.createElement('div');
    div.className = 'border p-4 rounded bg-gray-50';
    div.innerHTML = `
      <p class="font-semibold text-gray-800">${r.name}</p>
      <p class="text-sm text-yellow-500">${formatStars(r.rating)}</p>
      <p class="text-gray-700 mt-1">${r.text}</p>
      <p class="text-right text-xs text-gray-400 mt-2">${r.date}</p>
    `;
    reviewList.appendChild(div);
  });
}

function loadReviews() {
  return JSON.parse(localStorage.getItem('reviews') || '[]');
}

function saveReviews(reviews) {
  localStorage.setItem('reviews', JSON.stringify(reviews));
}

form.addEventListener('submit', function(e) {
  e.preventDefault();
  const name = form.name.value;
  const rating = parseInt(form.rating.value);
  const text = form.review.value;
  const date = new Date().toLocaleDateString('ko-KR');

  const newReview = { name, rating, text, date };
  const reviews = loadReviews();
  reviews.unshift(newReview);
  saveReviews(reviews);
  displayReviews(reviews);
  updateAverageRatingDisplay(reviews);
  form.reset();
  ratingInput.value = 0;
  selectedRating = 0;
  stars.forEach(s => s.classList.replace('text-yellow-400', 'text-gray-400'));
});

// 초기 렌더링
const reviews = loadReviews();
displayReviews(reviews);
updateAverageRatingDisplay(reviews);