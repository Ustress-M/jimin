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

### 1. 프로젝트 다운로드
```bash
git clone <repository-url>
cd jimin
```

### 2. 가상환경 생성 및 활성화
```bash
# 가상환경 생성
python3 -m venv vv

# 가상환경 활성화
# Windows:
vv\Scripts\activate
# macOS/Linux:
source vv/bin/activate
```

### 3. 필요한 패키지 설치
```bash
pip install -r requirements.txt
```

### 4. 애플리케이션 실행

#### 개발 환경:
```bash
python app.py
```

#### 서버 배포 (백그라운드 실행):
```bash
# 백그라운드에서 실행
nohup python3 app.py > output.log 2>&1 &

# 프로세스 확인
ps aux | grep python3

# 로그 확인
tail -f output.log
```

### 5. 웹브라우저에서 접속
- 개발 환경: `http://localhost:5550`
- 서버 환경: `http://서버IP:5550`

## 우분투 서버 배포 (권장)

### 자동 설치 및 실행:
```bash
# 스크립트 실행 권한 부여
chmod +x start_server.sh stop_server.sh

# 서버 시작 (모든 설정 자동 완료)
./start_server.sh
```

### 수동 설치 (우분투):
```bash
# 시스템 패키지 업데이트
sudo apt update

# Python3 및 필요한 패키지 설치
sudo apt install -y python3 python3-pip python3-venv

# 가상환경 생성
python3 -m venv vv
source vv/bin/activate

# pip 업그레이드
pip install --upgrade pip

# 프로젝트 패키지 설치
pip install -r requirements.txt

# 서버 실행
nohup python3 app.py > output.log 2>&1 &
```

### 서버 관리:
```bash
# 서버 중지
./stop_server.sh

# 로그 확인
tail -f output.log

# 프로세스 확인
ps aux | grep python3

# 포트 확인
netstat -tlnp | grep 5550
```

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
├── start_server.sh       # 서버 시작 스크립트 (우분투)
├── stop_server.sh        # 서버 중지 스크립트
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

## 서버 배포 시 주의사항

1. **포트 확인**: 기본 포트는 5550입니다.
2. **방화벽 설정**: 서버 방화벽에서 5550 포트를 열어주세요.
   ```bash
   # UFW 방화벽 사용 시
   sudo ufw allow 5550
   ```
3. **업로드 폴더 권한**: `static/uploads` 폴더에 쓰기 권한이 있는지 확인하세요.
4. **로그 모니터링**: `output.log` 파일을 통해 애플리케이션 상태를 확인하세요.
5. **시스템 서비스 등록** (선택사항): 서버 재부팅 시 자동 시작하려면 systemd 서비스로 등록하세요.

## 주의사항

- 현재는 메모리에 데이터를 저장하므로 서버 재시작 시 데이터가 초기화됩니다.
- 실제 운영 환경에서는 데이터베이스(예: SQLite, MySQL)를 사용하는 것을 권장합니다.
- 이미지 업로드 기능을 위해 `static/uploads` 폴더가 자동으로 생성됩니다. 