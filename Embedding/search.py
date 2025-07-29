import pandas as pd
from langchain.embeddings.infinity import InfinityEmbeddings
from langchain.vectorstores import FAISS
from langchain.docstore.document import Document

def main():
    # Load the data from the TSV file
    df = pd.read_csv('../Base de données Chants - tous les chants.tsv', sep='\t', engine='python')

    # Create a list of documents
    documents = []
    for index, row in df.iterrows():
        text = ""
        if pd.notna(row['Refrain']):
            text += row['Refrain'] + " "
        if pd.notna(row['Couplets 1 si après le R/']):
            text += row['Couplets 1 si après le R/'] + " "
        if pd.notna(row['Couplets 2']):
            text += row['Couplets 2'] + " "
        if pd.notna(row['Couplet 3']):
            text += row['Couplet 3'] + " "
        if pd.notna(row['Couplets 4+']):
            text += row['Couplets 4+']

        if text:
            documents.append(Document(page_content=text, metadata={"title": row['Titre']}))

    # Create the embeddings model
    emb_model = InfinityEmbeddings(
        model="intfloat/multilingual-e5-base",
        infinity_api_url="http://localhost:7997",
    )

    # Create the FAISS vector store
    try:
        db = FAISS.from_documents(documents, emb_model)
    except Exception as e:
        print(f"An error occurred while creating the vector store: {e}")
        print("Please ensure that the infinity embedding server is running.")
        return

    # Prompt the user for a sentence
    query = input("Enter a sentence to search for: ")

    # Perform the similarity search
    docs = db.similarity_search(query, k=10)

    # Print the results
    for doc in docs:
        print(f"Title: {doc.metadata['title']}")
        print(f"Text: {doc.page_content}")
        print("-" * 20)

if __name__ == "__main__":
    main()
