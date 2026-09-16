# ═════════════════════════════════════════════════════════════════════
#  pudding.bash — Bash integration for pudding
#  Source this file in your ~/.bashrc or ~/.bash_profile:
#    source /path/to/pudding/shell/pudding.bash
# ═════════════════════════════════════════════════════════════════════

export PUDDING_SESSION_ID="$$"
_pudding_exec_file="/tmp/.pudding_exec_$$"

_pudding_bash_precmd() {
    if [[ -f "$_pudding_exec_file" ]]; then
        local _pudding_to_run
        _pudding_to_run=$(<"$_pudding_exec_file")
        rm -f "$_pudding_exec_file"
        if [[ -n "$_pudding_to_run" ]]; then
            history -s "$_pudding_to_run" 2>/dev/null || true
            eval "$_pudding_to_run"
        fi
    fi
}

if [[ -z "${PROMPT_COMMAND:-}" ]]; then
    PROMPT_COMMAND="_pudding_bash_precmd"
elif [[ "$PROMPT_COMMAND" != *"_pudding_bash_precmd"* ]]; then
    PROMPT_COMMAND="_pudding_bash_precmd; $PROMPT_COMMAND"
fi

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

    local cmd="$raw_res"
    [[ "$raw_res" == ACTION:* ]] && cmd="${raw_res#ACTION:}"

    echo ""
    echo -e "  \033[1;37m›\033[0m \033[1;32m$cmd\033[0m"
    echo ""
    read -r -p "  ¿Ejecutar? [S/n] " confirm
    if [[ -z "$confirm" || "$confirm" =~ ^[sSyY]$ ]]; then
        history -s "$cmd" 2>/dev/null || true
        eval "$cmd"
    else
        echo "  — Cancelado."
    fi
    return 0
}
alias '?'='_pudding_query'

ai() {
    pudding --chat "$@"
}

command_not_found_handle() {
    local full_cmd="$*"

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
            read -r -p "  ¿Ejecutar? [S/n] " confirm
            if [[ -z "$confirm" || "$confirm" =~ ^[sSyY]$ ]]; then
                echo "$cmd" > "$_pudding_exec_file"
                return 0
            else
                echo "  — Cancelado."
                return 0
            fi
        fi
    fi

    echo "bash: $1: orden no encontrada"
    return 127
}
