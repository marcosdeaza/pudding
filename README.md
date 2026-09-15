# pudding 🍮

> **Clean, ultra-fast natural language bridge for your shell.**  
> Zero external dependencies. Works with any OpenAI-compatible API, DeepSeek, or local Ollama. Anti-slop, minimal, and blazing fast.

[![License: MIT](https://img.shields.io/badge/License-MIT-black.svg)](LICENSE)
[![Python: 3.8+](https://img.shields.io/badge/Python-3.8+-black.svg)](https://www.python.org/)
[![Shell: zsh%20%7C%20bash](https://img.shields.io/badge/Shell-zsh%20%7C%20bash-black.svg)](#)
[![Zero Dependencies](https://img.shields.io/badge/Dependencies-Zero-black.svg)](#)

---

## Why pudding?

Most AI terminal assistants either require heavy background daemons, force you into proprietary terminal emulators, spam emojis, or dump raw confusing kernel metrics.

**pudding** is different:
- **Zero dependencies**: Written in pure Python 3 using only the standard library (`urllib`, `json`, `subprocess`). No `pip install`, no `node_modules`, no background daemons eating your battery.
- **Provider agnostic**: Plug in **DeepSeek Flash**, **OpenAI ChatGPT**, local **Ollama** (100% offline & free), **Groq**, **LiteLLM**, or any OpenAI-compatible endpoint.
- **Dual-mode intelligence**:
  1. **Actions (Commands)**: Translates natural language requests into exact terminal commands (including multi-step commands chained with `&&`) and lets you execute them with a single keystroke (`Enter` or `S`).
  2. **Mapped System Inspection**: When you ask about your machine (`how much memory is left`, `what ports are listening`, `what is my IP`), it inspects the system in <5ms and returns concise, human-friendly numbers. No kernel page dumps, no cryptic hex tables.
- **Anti-slop**: No emojis, no markdown asterisk noise, no infinite loops. Pure Unix minimalism.
- **Natural question marks**: Built with `unsetopt nomatch` so queries like `whats using my cpu now?` never fail with shell globbing errors.

---

## Recommended Terminal: Ghostty

While **pudding** runs in any terminal (**iTerm2**, **Alacritty**, **Kitty**, **Apple Terminal**, **tmux**), it was built and tested primarily on **[Ghostty](https://ghostty.org)** — the modern, GPU-accelerated terminal by Mitchell Hashimoto.

Check out the [`extras/`](extras/) folder for:
- `extras/ghostty-noir.config`: High-contrast Noir monochrome theme (`#09090b` background, 94% opacity, transparent titlebar, full split keybindings).
- `extras/starship-noir.toml`: Ultra-clean grayscale Starship prompt.

---

## Quickstart

### 1. Clone & Install
```bash
git clone https://github.com/MARKITOS-E/pudding.git
cd pudding
./install.sh
```

### 2. Reload your shell
```bash
source ~/.zshrc   # or source ~/.bashrc
```

---

## Configuration & Providers

**pudding** can be configured via environment variables or through `~/.config/pudding/config.json`.

### Option A: DeepSeek Flash (Recommended: <350ms, smart, affordable)
Add to your `~/.zshrc` or `~/.bashrc`:
```bash
export PUDDING_API_BASE="https://api.deepseek.com/v1/chat/completions"
export PUDDING_MODEL="deepseek-chat"
export PUDDING_API_KEY="sk-your-deepseek-key"
```

### Option B: OpenAI / ChatGPT
```bash
export PUDDING_API_BASE="https://api.openai.com/v1/chat/completions"
export PUDDING_MODEL="gpt-4o-mini"
export PUDDING_API_KEY="sk-proj-your-openai-key"
```

### Option C: Local Ollama (100% Free, Private & Offline)
Run local models (e.g. `llama3.2:3b` or `minicpm-v`):
```bash
export PUDDING_API_BASE="http://localhost:11434/v1/chat/completions"
export PUDDING_MODEL="llama3.2:3b"
export PUDDING_API_KEY="ollama-local"
```

### Option D: JSON Configuration File
Create `~/.config/pudding/config.json`:
```json
{
  "api_url": "https://api.deepseek.com/v1/chat/completions",
  "model": "deepseek-chat",
  "api_key": "sk-your-api-key"
}
```

---

## Usage

### 1. The `?` Prefix (Fast Translation & Queries)

#### System Inspections (Mapped human answers):
```bash
~ › ? how much memory is left
  › RAM: 6.3 GB free of 16.0 GB (9.7 GB in use)
  › Disk: 215 GB free of 460 GB

~ › ? what is my IP
  › Local IP: 192.168.1.37 | Public IP: 88.17.104.151

~ › ? can you check cpu usage now?
  › CPU: 14.8% in use (top: WindowServer 4.1%, Spotify 3.2%)
```

#### Executable Commands:
```bash
~ › ? go to downloads
  › cd ~/Downloads
  ¿Ejecutar? [S/n]

~ › ? make a folder called api, enter it and create app.py
  › mkdir -p api && cd api && touch app.py
  ¿Ejecutar? [S/n]

~ › ? stealth SYN scan with OS detection on 192.168.1.1
  › sudo nmap -sS -O 192.168.1.1
  ¿Ejecutar? [S/n]
```
*(Press **Enter** or **S** to execute immediately, or **n** to cancel).*

---

### 2. Direct Natural Language (No prefix required)
If you type an instruction directly on your prompt:
```bash
~ › go to downloads
  › cd ~/Downloads
  ¿Ejecutar? [S/n]
```
*Note: Only multi-word sentences are intercepted; standard command typos will not trigger AI calls.*

---

### 3. Streaming Chat (`ai`)
For direct technical explanations, troubleshooting, or cybersecurity concepts:
```bash
# Single question
ai "explain how an ARP spoofing attack works and how to detect it"

# Interactive streaming chat session
ai
```

---

## Architecture & Project Structure

```
pudding/
├── bin/
│   └── pudding             # Standalone Python CLI (<300 lines, 0 dependencies)
├── shell/
│   ├── pudding.zsh         # Zsh integration (prefixed '?', nonomatch, handlers)
│   └── pudding.bash        # Bash integration equivalent
├── config/
│   └── config.example.json # Example multi-provider template
├── extras/
│   ├── ghostty-noir.config # Recommended Ghostty monochrome theme
│   └── starship-noir.toml  # Recommended Starship monochrome prompt
├── .env.example            # Ready-to-copy environment templates
├── install.sh              # 1-step installer
├── uninstall.sh            # Clean uninstaller
├── LICENSE                 # MIT License
└── README.md
```

---

## Contributing

Pull requests and issues are welcome! Feel free to fork this repository, add new shell integrations, or optimize inspection commands.

---

## License

MIT License. Copyright (c) 2026 Marcos de Aza. See [LICENSE](LICENSE) for details.
