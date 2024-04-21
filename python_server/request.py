
import ollama
import chromadb
from langchain_text_splitters import CharacterTextSplitter
from langchain_text_splitters import RecursiveCharacterTextSplitter
    
def postaviPitanje(fromfile, pitanje):

  # split it into chunks
  text_splitter = CharacterTextSplitter(
      separator="\n\n",
      chunk_size=1000,
      chunk_overlap=200,
      length_function=len,
      is_separator_regex=False,
  )

  text_splitter = CharacterTextSplitter(chunk_size=1000, chunk_overlap=0)
  pages = text_splitter.split_text(fromfile)

  text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=100)
  texts = text_splitter.create_documents(pages)

  client = chromadb.Client()
  try:
    collection = client.get_collection(name="docs")
  except:
    collection = client.create_collection(name="docs")

  for i, d in enumerate(pages):
    response = ollama.embeddings(model="nomic-embed-text", prompt=d)
    embedding = response["embedding"]
    collection.add(
      ids=[str(i)],
      embeddings=[embedding],
      documents=[d]
    )

  response = ollama.embeddings(
    prompt=pitanje,
    model="nomic-embed-text"
  )
  results = collection.query(
    query_embeddings=[response["embedding"]],
    n_results=1
  )
  data = results['documents'][0][0]
  output = ollama.generate(
    model="llama2:13b",
    prompt=f"Ti si asistent sa ciljem da uz pomoć ovih podataka: {data}, pomogneš studentima prilikom učenja. Odgovori na isključivo na srpskom jeziku za sledeći prompt: {pitanje}"
  )

  #print(output['response'])
  return output['response']

def sumarizuj(fromfile):

  # split it into chunks
  text_splitter = CharacterTextSplitter(
      separator="\n\n",
      chunk_size=1000,
      chunk_overlap=200,
      length_function=len,
      is_separator_regex=False,
  )

  text_splitter = CharacterTextSplitter(chunk_size=1000, chunk_overlap=0)
  pages = text_splitter.split_text(fromfile)

  text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=100)
  texts = text_splitter.create_documents(pages)

  client = chromadb.Client()
  try:
    collection = client.get_collection(name="docs")
  except:
    collection = client.create_collection(name="docs")

  for i, d in enumerate(pages):
    response = ollama.embeddings(model="nomic-embed-text", prompt=d)
    embedding = response["embedding"]
    collection.add(
      ids=[str(i)],
      embeddings=[embedding],
      documents=[d]
    )

  response = ollama.embeddings(
    prompt="Sumiraj mi celokupno gradivo u ne vise od 30 recenica",
    model="nomic-embed-text"
  )
  results = collection.query(
    query_embeddings=[response["embedding"]],
    n_results=1
  )
  data = results['documents'][0][0]

  #prikaz chuk teksta iz embeddinga
  #print(data)

  output = ollama.generate(
    model="llama2:13b",
    prompt=f"Ti si asistent pri učenju, i tvoj zadatak je da pomažeš studentima da spreme ispit.\
    Korišćenjem ovih podataka: {data} precizno sumarizuj podatke u maksimalno 30 recenica\
    Odgovor mora biti na srpskom jeziku obavezno!"
  )

  #print(output['response'])
  return output['response']


def generisiFlashKartice(fromfile):
  # split it into chunks
  text_splitter = CharacterTextSplitter(
      separator="\n\n",
      chunk_size=1000,
      chunk_overlap=200,
      length_function=len,
      is_separator_regex=False,
  )

  text_splitter = CharacterTextSplitter(chunk_size=1000, chunk_overlap=0)
  pages = text_splitter.split_text(fromfile)

  text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=100)
  texts = text_splitter.create_documents(pages)

  client = chromadb.Client()
  try:
    collection = client.get_collection(name="docs")
  except:
    collection = client.create_collection(name="docs")

  for i, d in enumerate(pages):
    response = ollama.embeddings(model="nomic-embed-text", prompt=d)
    embedding = response["embedding"]
    collection.add(
      ids=[str(i)],
      embeddings=[embedding],
      documents=[d]
    )

  results = collection.query(
    query_embeddings=[response["embedding"]],
    n_results=1
  )
  data = results['documents'][0][0]

  #prikaz chuk teksta iz embeddinga
  #print(data)

  output = ollama.generate(
    model="llama2:13b",
    prompt=f"Ti si asistent sa srpskog govornog područja koji pomaže pri učenju, i tvoj zadatak je da pomažeš studentima da spreme ispit. \
    Korišćenjem ovih podataka: {data} napravi mi pitanja i odgovore za flash kartice sa nasumičnim brojem pitanja u json formatu tipa \"prednja\":\"pitanje\", \"zadnja\":\"odgovor\"\
    Nemoj da dodajes nikakav drugi tekst. Pitanja i odgovori moraju biti na srpskom jeziku!"
  )

  #print(output['response'])
  return output['response']
