<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>숙박 목록</title>
  <style>
    .card {
      border: 1px solid #ddd;
      padding: 1em;
      margin: 1em;
      border-radius: 8px;
      max-width: 400px;
    }
    .card img {
      max-width: 100%;
      height: auto;
    }
    .pagination {
      margin: 1em;
    }
    .pagination button {
      margin: 0 5px;
      padding: 0.5em 1em;
    }
  </style>
</head>
<body>
  <h1>숙박 목록</h1>
  <div id="accommodation-list"></div>
  <div class="pagination" id="pagination"></div>

  <script>
    const itemsPerPage = 5;
    let currentPage = 1;
    let dataItems = [];

    function renderPage(page) {
      const list = document.getElementById('accommodation-list');
      list.innerHTML = ''; // 기존 내용 지우기

      const startIndex = (page - 1) * itemsPerPage;
      const endIndex = startIndex + itemsPerPage;
      const pageItems = dataItems.slice(startIndex, endIndex);

      pageItems.forEach(item => {
        const card = document.createElement('div');
        card.className = 'card';

        const title = `<h2>${item.title}</h2>`;
        const address = `<p>주소: ${item.addr1}</p>`;
        const phone = item.tel ? `<p>전화: ${item.tel}</p>` : '';
        const image = item.firstimage ? `<img src="${item.firstimage}" alt="${item.title}">` : '<p>[이미지 없음]</p>';

        card.innerHTML = image + title + address + phone;
        list.appendChild(card);
      });
    }

    function setupPagination(totalItems) {
      const pagination = document.getElementById('pagination');
      pagination.innerHTML = '';

      const pageCount = Math.ceil(totalItems / itemsPerPage);
      for (let i = 1; i <= pageCount; i++) {
        const btn = document.createElement('button');
        btn.textContent = i;
        btn.onclick = () => {
          currentPage = i;
          renderPage(currentPage);
          // 현재 페이지 버튼 강조를 위해 모든 버튼 스타일 초기화 후 다시 설정
          Array.from(pagination.children).forEach(child => child.style.fontWeight = 'normal');
          btn.style.fontWeight = 'bold';
        };
        if (i === currentPage) {
          btn.style.fontWeight = 'bold';
        }
        pagination.appendChild(btn);
      }
    }

    // lodgment.json 파일은 이 JSP 파일이 서비스되는 경로 기준으로 접근 가능해야 합니다.
    // 예를 들어, JSP가 /webapp/accommodation_list.jsp 라면,
    // lodgment.json도 /webapp/lodgment.json 에 위치하거나,
    // fetch 경로를 알맞게 수정해야 합니다. (예: fetch('data/lodgment.json') 또는 fetch('/myapp/data/lodgment.json'))
    fetch('lodgment.json')
      .then(response => {
        if (!response.ok) {
          throw new Error('Network response was not ok ' + response.statusText);
        }
        return response.json();
      })
      .then(data => {
        if (data && data.items) { // 데이터 구조 확인
            dataItems = data.items; // 전역 배열에 저장
            setupPagination(dataItems.length);
            renderPage(currentPage);
        } else {
            console.error('lodgment.json 데이터 형식이 올바르지 않습니다. "items" 배열이 필요합니다.');
            document.getElementById('accommodation-list').innerHTML = '<p>숙박 정보를 불러오는 데 실패했습니다. 데이터 형식을 확인해주세요.</p>';
        }
      })
      .catch(error => {
        console.error('숙박 정보를 불러오는 중 오류 발생:', error);
        document.getElementById('accommodation-list').innerHTML = '<p>숙박 정보를 불러오는 데 실패했습니다. 잠시 후 다시 시도해주세요.</p>';
      });
  </script>
</body>
</html>