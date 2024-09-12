# Use the official Ollama Docker image
ARG OLLAMA=0.3.10
FROM ollama/ollama:${OLLAMA}
ARG LLM=llama3

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install --no-install-recommends --assume-yes curl && \
    apt-get clean autoclean && apt-get autoremove --yes
RUN bash -c "nohup ollama serve &" && \
    curl --retry 30 --retry-connrefused --retry-delay 1 http://localhost:11434/api/tags && \
    ollama pull ${LLM}

HEALTHCHECK --interval=5m --timeout=3s --start-period=60s --retries=2 \
    CMD curl -f http://localhost:11434/api/tags 2>/dev/null || exit 1

# Expose port 11434
EXPOSE 11434

# Command to run Ollama and serve
ENTRYPOINT ["/bin/ollama"]
CMD ["serve"]