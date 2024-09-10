from langchain.embeddings.infinity import InfinityEmbeddings
from langchain.docstore.document import Document

documents = [Document(page_content="Hello world!", metadata={"source": "unknown"})]

emb_model = InfinityEmbeddings(model="intfloat/multilingual-e5-base", infinity_api_url="http://localhost:7997")
print(emb_model.embed_documents([doc.page_content for doc in docs]))