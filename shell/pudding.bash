# ═════════════════════════════════════════════════════════════════════
#  pudding.bash — Bash integration for pudding
#  Source this file in your ~/.bashrc or ~/.bash_profile:
#    source /path/to/pudding/shell/pudding.bash
# ═════════════════════════════════════════════════════════════════════

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

    if [[ "$raw_res" == INFO:* ]]; then
        local info_text="${raw_res#INFO:}"
        echo ""
        echo "$info_text" | while IFS= read -r line; do
            [[ -n "$line" ]] && echo -e "  \033[1;37m›\033[0m \033[0;37m$line\033[0m"
        done
        echo ""
        return 0
    fi

    if [[ "$raw_res" == ACTION:* ]]; then
        local cmd="${raw_res#ACTION:}"
        echo ""
        echo -e "  \033[1;37m›\033[0m \033[1;32m$cmd\033[0m"
        echo ""
        read -r -p "  ¿Ejecutar? [S/n] " confirm
        if [[ -z "$confirm" || "$confirm" =~ ^[sSyY]$ ]]; then
            eval "$cmd"
        else
            echo "  — Cancelado."
        fi
        return 0
    fi
}
alias '?'='_pudding_query'

ai() {
    pudding --chat "$@"
}
