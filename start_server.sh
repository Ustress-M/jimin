#!/bin/bash

# 산남고 분실함 서버 시작 스크립트 (Ubuntu 환경)

echo "=== 산남고 분실함 서버 시작 (Ubuntu) ==="

# 현재 디렉토리 확인
echo "현재 디렉토리: $(pwd)"

# 시스템 패키지 업데이트 및 Python3 설치 확인
echo "시스템 패키지 확인 중..."
if ! command -v python3 &> /dev/null; then
    echo "Python3가 설치되지 않았습니다. 설치 중..."
    sudo apt update
    sudo apt install -y python3 python3-pip python3-venv
fi

if ! command -v python3-venv &> /dev/null; then
    echo "python3-venv 설치 중..."
    sudo apt install -y python3-venv
fi

# 가상환경 활성화
if [ -d "vv" ]; then
    echo "가상환경 활성화 중..."
    source vv/bin/activate
    echo "가상환경 활성화 완료"
else
    echo "가상환경이 없습니다. 생성 중..."
    python3 -m venv vv
    source vv/bin/activate
    echo "가상환경 생성 및 활성화 완료"
fi

# pip 업그레이드
echo "pip 업그레이드 중..."
pip install --upgrade pip

# 필요한 패키지 설치
echo "패키지 설치 중..."
pip install -r requirements.txt

# 업로드 폴더 생성 및 권한 설정
if [ ! -d "static/uploads" ]; then
    echo "업로드 폴더 생성 중..."
    mkdir -p static/uploads
fi

# 폴더 권한 설정 (Ubuntu 환경)
echo "폴더 권한 설정 중..."
chmod 755 static/uploads
chown -R $USER:$USER static/uploads

# 기존 프로세스 종료
echo "기존 프로세스 확인 중..."
if [ -f "server.pid" ]; then
    OLD_PID=$(cat server.pid)
    if ps -p $OLD_PID > /dev/null 2>&1; then
        echo "기존 프로세스 종료 중 (PID: $OLD_PID)..."
        kill $OLD_PID
        sleep 2
    fi
    rm -f server.pid
fi

# screen 세션 종료 (있다면)
screen -S jimin_server -X quit > /dev/null 2>&1

# 서버 시작 (터미널 종료 후에도 계속 실행)
echo "서버 시작 중... (포트: 5550)"
echo "터미널을 종료해도 서버는 계속 실행됩니다."

# screen 세션에서 서버 실행
screen -dmS jimin_server bash -c "
    cd $(pwd)
    source vv/bin/activate
    python3 app.py > output.log 2>&1
    echo \$! > server.pid
"

# 잠시 대기 후 프로세스 확인
sleep 3

# 프로세스 ID 확인
if [ -f "server.pid" ]; then
    PID=$(cat server.pid)
    if ps -p $PID > /dev/null 2>&1; then
        echo "=== 서버 시작 완료 ==="
        echo "프로세스 ID: $PID"
        echo "Screen 세션: jimin_server"
        echo ""
        echo "관리 명령어:"
        echo "  상태 확인: ./status_server.sh"
        echo "  서버 중지: ./stop_server.sh"
        echo "  로그 확인: tail -f output.log"
        echo "  Screen 세션 접속: screen -r jimin_server"
        echo ""
        echo "서버 접속: http://$(hostname -I | awk '{print $1}'):5550"
    else
        echo "서버 시작 실패. 로그를 확인하세요: tail -f output.log"
    fi
else
    echo "서버 시작 실패. 로그를 확인하세요: tail -f output.log"
fi 