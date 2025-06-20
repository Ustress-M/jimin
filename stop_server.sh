#!/bin/bash

# 산남고 분실함 서버 중지 스크립트

echo "=== 산남고 분실함 서버 중지 ==="
echo ""

# 프로세스 ID 확인 및 종료
if [ -f "server.pid" ]; then
    PID=$(cat server.pid)
    echo "📋 프로세스 ID: $PID"
    
    if ps -p $PID > /dev/null 2>&1; then
        echo "🛑 프로세스 종료 중..."
        kill $PID
        
        # 프로세스가 완전히 종료될 때까지 대기
        for i in {1..10}; do
            if ! ps -p $PID > /dev/null 2>&1; then
                echo "✅ 프로세스가 성공적으로 종료되었습니다."
                break
            fi
            echo "   대기 중... ($i/10)"
            sleep 1
        done
        
        # 강제 종료 (필요시)
        if ps -p $PID > /dev/null 2>&1; then
            echo "⚠️  강제 종료 중..."
            kill -9 $PID
            sleep 1
            if ! ps -p $PID > /dev/null 2>&1; then
                echo "✅ 프로세스가 강제 종료되었습니다."
            else
                echo "❌ 프로세스 종료 실패"
            fi
        fi
    else
        echo "ℹ️  프로세스가 이미 종료되었습니다."
    fi
    
    # PID 파일 삭제
    rm -f server.pid
    echo "🗑️  PID 파일 삭제됨"
else
    echo "ℹ️  server.pid 파일이 없습니다."
fi

# Screen 세션 종료
echo ""
echo "🖥️  Screen 세션 종료 중..."
if screen -list | grep jimin_server > /dev/null; then
    screen -S jimin_server -X quit
    echo "✅ Screen 세션이 종료되었습니다."
else
    echo "ℹ️  Screen 세션이 없습니다."
fi

# 포트 사용 확인
echo ""
echo "🌐 포트 사용 현황 확인:"
if netstat -tlnp 2>/dev/null | grep 5550 > /dev/null; then
    echo "⚠️  포트 5550이 여전히 사용 중입니다:"
    netstat -tlnp | grep 5550
else
    echo "✅ 포트 5550이 해제되었습니다."
fi

echo ""
echo "=== 서버 중지 완료 ==="
echo ""
echo "🔧 관리 명령어:"
echo "  서버 시작: ./start_server.sh"
echo "  상태 확인: ./status_server.sh"
echo "  로그 확인: tail -f output.log" 