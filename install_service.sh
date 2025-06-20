#!/bin/bash

# 산남고 분실함 systemd 서비스 설치 스크립트

echo "=== 산남고 분실함 systemd 서비스 설치 ==="

# 현재 사용자 확인
CURRENT_USER=$(whoami)
CURRENT_DIR=$(pwd)

echo "현재 사용자: $CURRENT_USER"
echo "현재 디렉토리: $CURRENT_DIR"

# 서비스 파일 수정
echo "서비스 파일 수정 중..."
sed -i "s|User=ubuntu|User=$CURRENT_USER|g" jimin.service
sed -i "s|WorkingDirectory=/home/ubuntu/jimin|WorkingDirectory=$CURRENT_DIR|g" jimin.service
sed -i "s|Environment=PATH=/home/ubuntu/jimin/vv/bin|Environment=PATH=$CURRENT_DIR/vv/bin|g" jimin.service
sed -i "s|ExecStart=/home/ubuntu/jimin/vv/bin/python3 /home/ubuntu/jimin/app.py|ExecStart=$CURRENT_DIR/vv/bin/python3 $CURRENT_DIR/app.py|g" jimin.service

# 서비스 파일 복사
echo "서비스 파일 복사 중..."
sudo cp jimin.service /etc/systemd/system/

# systemd 재로드
echo "systemd 재로드 중..."
sudo systemctl daemon-reload

# 서비스 활성화
echo "서비스 활성화 중..."
sudo systemctl enable jimin.service

echo "=== 설치 완료 ==="
echo ""
echo "서비스 관리 명령어:"
echo "  시작: sudo systemctl start jimin"
echo "  중지: sudo systemctl stop jimin"
echo "  재시작: sudo systemctl restart jimin"
echo "  상태 확인: sudo systemctl status jimin"
echo "  로그 확인: sudo journalctl -u jimin -f"
echo ""
echo "서버 재부팅 시 자동으로 시작됩니다." 