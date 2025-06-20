# 산남고 분실함

산남고등학교 교내 분실물 찾기 사이트입니다.

## 기능

- **홈페이지**: 최근 습득된 분실물 3개 표시 (마우스 오버 시 상세 정보)
- **검색**: 분실물 이름과 특징으로 검색
- **전체 분실물 목록**: 페이지네이션으로 분실물 목록 확인
- **습득물 등록**: 사진, 물건이름, 발견일시, 물건 특징 등록
- **분실물 등록**: 사진(선택), 물건이름, 분실일시, 학번, 이름, 분실물 특징 등록

## 상태 표시

- 🔴 빨간색 원: 분실자가 신청한 물건
- 🔵 파란색 원: 습득되어 학생회실에 보관중인 물건

## 설치 및 실행

1. 필요한 패키지 설치:
```bash
pip install -r requirements.txt
```

2. 애플리케이션 실행:
```bash
python app.py
```

3. 웹브라우저에서 `http://localhost:5000` 접속

## 기술 스택

- **Backend**: Flask (Python)
- **Frontend**: Bootstrap 5, HTML, CSS, JavaScript
- **템플릿 엔진**: Jinja2

## 프로젝트 구조

```
jimin/
├── app.py                 # Flask 애플리케이션 메인 파일
├── requirements.txt       # 필요한 패키지 목록
├── README.md             # 프로젝트 설명
├── templates/            # HTML 템플릿
│   ├── base.html         # 기본 레이아웃
│   ├── index.html        # 홈페이지
│   ├── found_items.html  # 전체 분실물 목록
│   ├── register_found.html # 습득물 등록
│   ├── register_lost.html  # 분실물 등록
│   └── search_results.html # 검색 결과
└── static/               # 정적 파일
    ├── css/
    │   └── style.css     # 사용자 정의 스타일
    ├── js/
    │   └── script.js     # JavaScript 기능
    └── uploads/          # 업로드된 이미지 저장소
```

## 주의사항

- 현재는 메모리에 데이터를 저장하므로 서버 재시작 시 데이터가 초기화됩니다.
- 실제 운영 환경에서는 데이터베이스(예: SQLite, MySQL)를 사용하는 것을 권장합니다.
- 이미지 업로드 기능을 위해 `static/uploads` 폴더가 자동으로 생성됩니다. 