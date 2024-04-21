import PyPDF2
import re

def clean_text(text):
  
  text = re.sub(r'[^\x00-\x7F\u0400-\u0460\u0041-\u0200\n]+', '', text) 
  text = re.sub(r'\s{2,}\n', ' ', text)     
  return text

def extract_text_to_txt(pdf_path, output_txt_path, encoding='utf-8'):
  with open(pdf_path, 'rb') as pdf_file:
    pdf_reader = PyPDF2.PdfReader(pdf_file)

    text = ""
    num_pages = len(pdf_reader.pages)
    for page_num in range(num_pages):
      page = pdf_reader.pages[page_num]
      text += page.extract_text()


    try:
      text = text.encode(encoding).decode('utf-8')
    except UnicodeDecodeError:
      print("Warning: Potential encoding issue. Using 'utf-8' fallback.")
      text = text.encode('utf-8', errors='replace').decode('utf-8')

    text = clean_text(text)
    with open(output_txt_path, 'w', encoding=encoding) as txt_file:
      txt_file.write(text)

  print(f"Text extracted from '{pdf_path}' and saved to '{output_txt_path}'.")

# Example usage
#pdf_path = "data/pdfs/file.pdf"
#output_txt_path = "data/raw/file.txt"
#extract_text_to_txt(pdf_path, output_txt_path)

def extract(predmet):
  extract_text_to_txt(f"data/pdfs/{predmet}.pdf", f"data/raw/{predmet}.txt")


extract("ProgramskiJezici")