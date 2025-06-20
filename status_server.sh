#!/bin/bash

# 산남고 분실함 서버 상태 확인 스크립트

echo "=== 산남고 분실함 서버 상태 확인 ==="
echo ""

# 프로세스 ID 확인
if [ -f "server.pid" ]; then
    PID=$(cat server.pid)
    echo "📋 프로세스 ID: $PID"
    
    # 프로세스 실행 상태 확인
    if ps -p $PID > /dev/null 2>&1; then
        echo "✅ 서버 상태: 실행 중"
        
        # 프로세스 상세 정보
        echo ""
        echo "📊 프로세스 정보:"
        ps -p $PID -o pid,ppid,cmd,etime,pcpu,pmem --no-headers
        
        # 포트 사용 확인
        echo ""
        echo "🌐 포트 사용 현황:"
        if netstat -tlnp 2>/dev/null | grep 5550 > /dev/null; then
            netstat -tlnp | grep 5550
        else
            echo "포트 5550에서 서비스가 실행되지 않습니다."
        fi
        
        # 메모리 사용량
        echo ""
        echo "💾 메모리 사용량:"
        ps -p $PID -o pid,vsz,rss,pmem --no-headers | awk '{print "PID: " $1 ", 가상메모리: " $2 "KB, 물리메모리: " $3 "KB, 메모리사용률: " $4 "%"}'
        
        # Screen 세션 확인
        echo ""
        echo "🖥️  Screen 세션:"
        if screen -list | grep jimin_server > /dev/null; then
            echo "✅ jimin_server 세션이 실행 중입니다."
            screen -list | grep jimin_server
        else
            echo "❌ jimin_server 세션이 없습니다."
        fi
        
        # 최근 로그 확인
        echo ""
        echo "📝 최근 로그 (마지막 5줄):"
        if [ -f "output.log" ]; then
            tail -5 output.log
        else
            echo "로그 파일이 없습니다."
        fi
        
    else
        echo "❌ 서버 상태: 실행되지 않음"
        echo "프로세스 ID $PID가 존재하지 않습니다."
        rm -f server.pid
    fi
else
    echo "❌ 서버 상태: 실행되지 않음"
    echo "server.pid 파일이 없습니다."
fi

echo ""
echo "🔧 관리 명령어:"
echo "  서버 시작: ./start_server.sh"
echo "  서버 중지: ./stop_server.sh"
echo "  로그 실시간 확인: tail -f output.log"
echo "  Screen 세션 접속: screen -r jimin_server"
echo "  Screen 세션 목록: screen -list" 