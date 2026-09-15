# ═════════════════════════════════════════════════════════════════════
#  pudding.zsh — Zsh integration for pudding
#  Source this file in your ~/.zshrc:
#    source /path/to/pudding/shell/pudding.zsh
# ═════════════════════════════════════════════════════════════════════

# Allow natural queries ending with '?' without zsh globbing error
unsetopt nomatch

# Prefix "?" for natural language commands and system questions
# Examples:
#   ? entra a descargas
#   ? cuanta memoria me queda
#   ? escaneo sigiloso nmap a 192.168.1.1
_pudding_query() {
    if [[ $# -eq 0 ]]; then
        echo "  Uso: ? <instrucción o consulta>"
        return 1
    fi
    local query="$*"
    local raw_res
    raw_res=$(pudding "$query" 2>/dev/null)
    
    if [[ -z "$raw_res" || "$raw_res" == "NONE" ]]; then
        echo "  ✗ No se detectó una instrucción o consulta válida."
        return 1
    fi

    # Mapped informational answer (RAM, Disk, CPU, Ports, IP, etc.)
    if [[ "$raw_res" == INFO:* ]]; then
        local info_text="${raw_res#INFO:}"
        echo ""
        echo "$info_text" | while IFS= read -r line; do
            [[ -n "$line" ]] && echo -e "  \033[1;37m›\033[0m \033[0;37m$line\033[0m"
        done
        echo ""
        return 0
    fi

    # Executable action command(s)
    if [[ "$raw_res" == ACTION:* ]]; then
        local cmd="${raw_res#ACTION:}"
        echo ""
        echo -e "  \033[1;37m›\033[0m \033[1;32m$cmd\033[0m"
        echo ""
        echo -n "  ¿Ejecutar? [S/n] "
        read -r confirm
        if [[ -z "$confirm" || "$confirm" =~ ^[sSyY]$ ]]; then
            eval "$cmd"
        else
            echo "  — Cancelado."
        fi
        return 0
    fi

    # Fallback
    echo ""
    echo -e "  \033[1;37m›\033[0m \033[1;32m$raw_res\033[0m"
    echo ""
    echo -n "  ¿Ejecutar? [S/n] "
    read -r confirm
    if [[ -z "$confirm" || "$confirm" =~ ^[sSyY]$ ]]; then
        eval "$raw_res"
    else
        echo "  — Cancelado."
    fi
}
alias '?'='noglob _pudding_query'

# Interactive and direct streaming chat
# Examples:
#   ai "explica cómo funciona un buffer overflow"
#   ai
ai() {
    pudding --chat "$@"
}

# Seamless fallback for natural language typed without '?'
_PUDDING_RECURSION_GUARD=0
command_not_found_handler() {
    if [[ $_PUDDING_RECURSION_GUARD -eq 1 ]]; then
        _PUDDING_RECURSION_GUARD=0
        echo "zsh: comando no encontrado: $1"
        return 127
    fi

    local full_cmd="$*"

    # Only process multi-word sentences to avoid intercepting typos
    if [[ "$full_cmd" == *" "* ]]; then
        local raw_res
        raw_res=$(pudding "$full_cmd" 2>/dev/null)

        if [[ "$raw_res" == INFO:* ]]; then
            local info_text="${raw_res#INFO:}"
            echo ""
            echo "$info_text" | while IFS= read -r line; do
                [[ -n "$line" ]] && echo -e "  \033[1;37m›\033[0m \033[0;37m$line\033[0m"
            done
            echo ""
            return 0
        elif [[ "$raw_res" == ACTION:* ]]; then
            local cmd="${raw_res#ACTION:}"
            echo ""
            echo -e "  \033[1;37m›\033[0m \033[1;32m$cmd\033[0m"
            echo ""
            echo -n "  ¿Ejecutar? [S/n] "
            read -r confirm
            if [[ -z "$confirm" || "$confirm" =~ ^[sSyY]$ ]]; then
                _PUDDING_RECURSION_GUARD=1
                eval "$cmd"
                local ret=$?
                _PUDDING_RECURSION_GUARD=0
                return $ret
            else
                echo "  — Cancelado."
                return 0
            fi
        fi
    fi

    echo "zsh: comando no encontrado: $1"
    return 127
}
