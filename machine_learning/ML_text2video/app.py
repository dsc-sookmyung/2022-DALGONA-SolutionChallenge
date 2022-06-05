# from flask import Flask
# app = Flask(__name__)
# @app.route('/')
# def home():
#     return 'Hello, World!'
# if __name__ == '__main__':
#     app.run(debug=True)

from flask import Flask, jsonify, request
import subprocess
import platform

app = Flask(__name__)
# run_with_ngrok(app)  
  
@app.route('/custom/video', methods=['POST'])
def create_video():
  if request.method == 'POST':
    input_text = request.form.get('input_text')
    print("server input_text : ",input_text)
    video_url = create_and_get_video_url(input_text)
    return jsonify({'video_url': video_url})

def create_and_get_video_url(input_text):
  command = 'python inference.py --checkpoint_path checkpoints/wav2lip_gan.pth --text \"animalforest\"'
  subprocess.call(command, shell=platform.system() != 'Windows')
  # 경로 + 파일명
  # 'results/result_voice.mp4'
  # return 'results/'+input_text+'.mp4'
  return 'https://storage.googleapis.com/zerozone-custom-video/'+input_text+".mp4"

@app.route("/")
def home():
    return "<h1>GFG is great platform to learn</h1>"

app.run()