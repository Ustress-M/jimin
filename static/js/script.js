// 마우스 오버 시 정보 표시 기능
document.addEventListener('DOMContentLoaded', function() {
    const itemCards = document.querySelectorAll('.item-card');
    
    itemCards.forEach(card => {
        const itemInfo = card.querySelector('.item-info');
        
        if (itemInfo) {
            card.addEventListener('mouseenter', function() {
                itemInfo.style.display = 'block';
            });
            
            card.addEventListener('mouseleave', function() {
                itemInfo.style.display = 'none';
            });
        }
    });
});

// 파일 업로드 미리보기 기능
function previewImage(input) {
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        
        reader.onload = function(e) {
            const preview = document.getElementById('image-preview');
            if (preview) {
                preview.src = e.target.result;
                preview.style.display = 'block';
            }
        };
        
        reader.readAsDataURL(input.files[0]);
    }
}

// 폼 유효성 검사
function validateForm(form) {
    const requiredFields = form.querySelectorAll('[required]');
    let isValid = true;
    
    requiredFields.forEach(field => {
        if (!field.value.trim()) {
            field.classList.add('is-invalid');
            isValid = false;
        } else {
            field.classList.remove('is-invalid');
        }
    });
    
    return isValid;
}

// 검색 기능 개선
function performSearch() {
    const searchInput = document.querySelector('input[name="q"]');
    if (searchInput && searchInput.value.trim()) {
        return true;
    }
    alert('검색어를 입력해주세요.');
    return false;
} 