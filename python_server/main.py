from flask import Flask, request, jsonify, send_file
from flask import make_response
from request import postaviPitanje
from request import generisiFlashKartice
import json 

app = Flask(__name__)

def citajFajl(filename):
  try:
    with open(filename, 'r', encoding="utf-8") as f:
      return f.read()
  except Exception as e:
    return "nofile"

def getPitanja(naziv):
  print(f"./data/questions/{naziv}.json")
  data = citajFajl(f"./data/questions/{naziv}.json")
  if data == "nofile":
    return []
  return json.loads(data)

def getPredmeti():
  lista = ["AOR2", "ProgramskiJezici", "BazePodataka"]
  predmeti = {
    "broj": len(lista),
    "nazivi": lista
  }
  return predmeti
  

@app.route("/predmeti")
def predmeti():
  return jsonify(getPredmeti())

@app.route("/pitanja/<naziv>")
def pitanja(naziv):
  return jsonify(getPitanja(naziv))

@app.route("/pitanjaind/<naziv>/<index>")
def pitanjaind(naziv, index):
  return jsonify(getPitanja(naziv)[int(index)-1])

@app.route("/pitaj/<predmet>/<pitanje>")
def pitaj(predmet, pitanje):
  fajl = citajFajl(f"data/raw/{predmet}.txt")
  if(fajl != "nofile"):
    return postaviPitanje(fajl, pitanje)
  return "Greska u nazivu predmeta!"

@app.route("/getPDF/<filename>")
def getPDF(filename):
  try:
    filepath = f"./data/pdfs/{filename}.pdf"
    return send_file(filepath, as_attachment=True)
  except FileNotFoundError:
    return make_response("File not found!", 404)

@app.route("/")
def hello():
    return "<h1>Dobrošli na API<h1>"


if __name__ == "__main__":
  app.run(host="0.0.0.0", debug=True)