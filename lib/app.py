from flask import Flask, jsonify, request
from flask_cors import CORS
import mysql.connector

app = Flask(__name__)
CORS(app)


db = mysql.connector.connect(
    host="192.168.1.245",
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


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
