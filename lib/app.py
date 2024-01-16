from flask import Flask, jsonify, request, send_file
from flask_cors import CORS
import os
import shutil
import mysql.connector
from io import BytesIO


app = Flask(__name__)
CORS(app)

db = mysql.connector.connect(
    host="localhost",
    user="flutter_user",
    password="",
    database="karaoke",
    port=3306
)


@app.route('/api/getSongs')
def get_data():
    id = request.args.get('id')
    language = request.args.get('language')
    genre = request.args.get('genre')

    cursor = db.cursor(dictionary=True)
    query = "SELECT * FROM songs"

    if language != '' and genre != '':
        query += f" WHERE lang = '{language}' AND genre = '{genre}'"
    elif language != '':
        query += f" WHERE lang = '{language}'"
    elif genre != '':
        query += f" WHERE genre = '{genre}'"

    cursor.execute(query)
    result = cursor.fetchall()
    cursor.close()

    return jsonify(result)



base_path = 'C:\\Users\\ankri\\songs\\'
def create_zip_archive(mp3_path, lrc_path):
    zip_buffer = BytesIO()
    with shutil.ZipFile(zip_buffer, 'w') as zip_archive:
        zip_archive.write(mp3_path, os.path.basename(mp3_path))
        zip_archive.write(lrc_path, os.path.basename(lrc_path))
    zip_buffer.seek(0)
    return zip_buffer

@app.route('/api/getFile')
def get_file():
    id = request.args.get('id')
    file_type = request.args.get('fileType')

    mp3_file_path = os.path.join(base_path, f'song-{id}.mp3')
    lrc_file_path = os.path.join(base_path, f'song-{id}.lrc')

    if file_type == 'mp3':
        file_path = mp3_file_path
    elif file_type == 'lrc':
        file_path = lrc_file_path
    else:
        return jsonify({'error': 'Invalid file type'}), 400

    if os.path.exists(file_path):
        return send_file(file_path, as_attachment=True, download_name=f'song-{id}.{file_type}')
    else:
        return jsonify({'error': 'File not found'}), 404

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
