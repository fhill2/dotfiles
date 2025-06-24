# Step 1: Install Ollama (Local Server Backend)
curl -fsSL https://ollama.com/install.sh | sh
ollama run deepseek-coder-v2:16b

# Step 2: Install llm python lib for (CLI frontend)
# apt install llm - the system installed version does not allow installing plugins
# Therefore create a virtual environment in the $HOME directory to use python llm from
uv venv $HOMER/venvs/ai
source $HOME/venvs/ai/bin/activate
uv pip install llm
llm install llm-ollama
