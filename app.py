from flask import Flask, render_template, request, redirect, url_for, flash, session
from datetime import datetime
import os
from werkzeug.utils import secure_filename

app = Flask(__name__)
app.secret_key = 'sannamgo_lost_found_secret_key'

# 업로드 폴더 설정
UPLOAD_FOLDER = 'static/uploads'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}

if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

# 임시 데이터 저장 (실제로는 데이터베이스를 사용해야 함)
found_items = []
lost_items = []

# 관리자 계정 (실제로는 데이터베이스에 저장해야 함)
ADMIN_USERNAME = 'admin'
ADMIN_PASSWORD = 'admin123'

def is_admin():
    return session.get('is_admin', False)

@app.route('/')
def index():
    # 최근 습득된 분실물 3개만 표시 (완료되지 않은 것만, 최근 순으로 정렬)
    active_found = [item for item in found_items if item['status'] != 'completed']
    # ID 기준으로 최근 순 정렬 (ID가 클수록 최근)
    active_found.sort(key=lambda x: x['id'], reverse=True)
    recent_found = active_found[:3] if len(active_found) >= 3 else active_found
    return render_template('index.html', recent_found=recent_found)

@app.route('/search')
def search():
    query = request.args.get('q', '')
    if query:
        # 분실물과 습득물에서 검색 (완료되지 않은 것만)
        search_results = []
        for item in found_items + lost_items:
            if (item['status'] != 'completed' and item['status'] != 'resolved') and (query.lower() in item['name'].lower() or query.lower() in item.get('description', '').lower()):
                search_results.append(item)
        return render_template('search_results.html', results=search_results, query=query)
    return redirect(url_for('index'))

@app.route('/found_items')
def found_items_page():
    # 최근 순으로 정렬 (ID가 클수록 최근)
    sorted_found_items = sorted(found_items, key=lambda x: x['id'], reverse=True)
    
    page = request.args.get('page', 1, type=int)
    per_page = 4
    start = (page - 1) * per_page
    end = start + per_page
    items = sorted_found_items[start:end]
    total_pages = (len(found_items) + per_page - 1) // per_page
    return render_template('found_items.html', items=items, page=page, total_pages=total_pages, is_admin=is_admin())

@app.route('/lost_items')
def lost_items_page():
    page = request.args.get('page', 1, type=int)
    per_page = 4
    start = (page - 1) * per_page
    end = start + per_page
    items = lost_items[start:end]
    total_pages = (len(lost_items) + per_page - 1) // per_page
    return render_template('lost_items.html', items=items, page=page, total_pages=total_pages, is_admin=is_admin())

@app.route('/lost_requests')
def lost_requests_page():
    # 분실 신청된 물건들만 필터링하고 최근 순으로 정렬
    lost_request_items = [item for item in lost_items if item['status'] == 'lost_request']
    # ID 기준으로 최근 순 정렬 (ID가 클수록 최근)
    lost_request_items.sort(key=lambda x: x['id'], reverse=True)
    
    page = request.args.get('page', 1, type=int)
    per_page = 4
    start = (page - 1) * per_page
    end = start + per_page
    items = lost_request_items[start:end]
    total_pages = (len(lost_request_items) + per_page - 1) // per_page
    return render_template('lost_requests.html', items=items, page=page, total_pages=total_pages, is_admin=is_admin())

@app.route('/register_found', methods=['GET', 'POST'])
def register_found():
    if request.method == 'POST':
        name = request.form['name']
        location = request.form['location']
        found_time = request.form['found_time']
        description = request.form['description']
        
        image = None
        if 'image' in request.files:
            file = request.files['image']
            if file and allowed_file(file.filename):
                filename = secure_filename(file.filename)
                file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
                image = filename
        
        new_item = {
            'id': len(found_items) + 1,
            'name': name,
            'image': image or 'default.png',
            'location': location,
            'found_time': found_time,
            'description': description,
            'status': 'found'
        }
        found_items.append(new_item)
        flash('습득물이 등록되었습니다!', 'success')
        return redirect(url_for('found_items_page'))
    
    return render_template('register_found.html')

@app.route('/register_lost', methods=['GET', 'POST'])
def register_lost():
    if request.method == 'POST':
        name = request.form['name']
        lost_time = request.form['lost_time']
        student_id = request.form['student_id']
        student_name = request.form['student_name']
        description = request.form['description']
        
        image = None
        if 'image' in request.files:
            file = request.files['image']
            if file and allowed_file(file.filename):
                filename = secure_filename(file.filename)
                file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
                image = filename
        
        new_item = {
            'id': len(lost_items) + 1,
            'name': name,
            'image': image or 'default.png',
            'lost_time': lost_time,
            'student_id': student_id,
            'student_name': student_name,
            'description': description,
            'status': 'lost_request'
        }
        lost_items.append(new_item)
        flash('분실물이 등록되었습니다!', 'success')
        return redirect(url_for('index'))
    
    return render_template('register_lost.html')

# 관리자 로그인
@app.route('/admin/login', methods=['GET', 'POST'])
def admin_login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        
        if username == ADMIN_USERNAME and password == ADMIN_PASSWORD:
            session['is_admin'] = True
            flash('관리자로 로그인되었습니다.', 'success')
            return redirect(url_for('admin_dashboard'))
        else:
            flash('잘못된 로그인 정보입니다.', 'error')
    
    return render_template('admin_login.html')

# 관리자 로그아웃
@app.route('/admin/logout')
def admin_logout():
    session.pop('is_admin', None)
    flash('로그아웃되었습니다.', 'success')
    return redirect(url_for('index'))

# 관리자 대시보드
@app.route('/admin')
def admin_dashboard():
    if not is_admin():
        return redirect(url_for('admin_login'))
    
    return render_template('admin_dashboard.html', 
                         found_items=found_items, 
                         lost_items=lost_items)

# 분실물 상태 변경
@app.route('/admin/update_status/<item_type>/<int:item_id>', methods=['POST'])
def update_status(item_type, item_id):
    if not is_admin():
        return redirect(url_for('admin_login'))
    
    new_status = request.form['status']
    
    if item_type == 'found':
        for item in found_items:
            if item['id'] == item_id:
                item['status'] = new_status
                flash('습득물 상태가 업데이트되었습니다.', 'success')
                break
    elif item_type == 'lost':
        for item in lost_items:
            if item['id'] == item_id:
                item['status'] = new_status
                flash('분실물 상태가 업데이트되었습니다.', 'success')
                break
    
    return redirect(url_for('admin_dashboard'))

# 분실물 삭제
@app.route('/admin/delete/<item_type>/<int:item_id>', methods=['POST'])
def delete_item(item_type, item_id):
    if not is_admin():
        return redirect(url_for('admin_login'))
    
    if item_type == 'found':
        global found_items
        found_items = [item for item in found_items if item['id'] != item_id]
        flash('습득물이 삭제되었습니다.', 'success')
    elif item_type == 'lost':
        global lost_items
        lost_items = [item for item in lost_items if item['id'] != item_id]
        flash('분실물이 삭제되었습니다.', 'success')
    
    return redirect(url_for('admin_dashboard'))

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8080) 