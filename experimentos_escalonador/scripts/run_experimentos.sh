SCENARIOS="$1"
shift
IO_OPS="$1"; shift
CPU_OPS="$1"; shift
REPETICOES="$1"; shift
EXECUTAVEL="$1"; shift
RESULTADOS="$1"; shift

for qtde in $SCENARIOS; do
    dir="$RESULTADOS/cenario_$qtde"
    if [ -z "${RESULTADOS}" ]; then
        printf 'Erro: variavel RESULTADOS vazia. Passe o caminho para salvar os resultados.\n' >&2
        exit 1
    fi
    if ! mkdir -p "$dir"; then
        printf 'Erro: falha ao criar o diretorio %s\n' "$dir" >&2
        exit 1
    fi
    printf 'cenario=%s\nio_ops=%s\ncpu_ops=%s\nrepeticoes=%s\n\nexecucao\tmedia_io\tmedia_cpu\n' "$qtde" "$IO_OPS" "$CPU_OPS" "$REPETICOES" > "$dir/resumo.txt"
    total_io=0
    total_cpu=0
    cont_io=0
    cont_cpu=0
    repeticao=1
    while [ "$repeticao" -le "$REPETICOES" ]; do
        saida_tmp="$dir/exec_$repeticao.saida"
        ./"$EXECUTAVEL" "$qtde" "$IO_OPS" "$CPU_OPS" 2>&1 | tee "$saida_tmp"
        media_io=$(awk '/^IO[[:space:]]/ { soma += $3; contador += 1 } END { if (contador > 0) printf "%.6f", soma / contador; else printf "0.000000" }' "$saida_tmp")
        media_cpu=$(awk '/^CPU[[:space:]]/ { soma += $3; contador += 1 } END { if (contador > 0) printf "%.6f", soma / contador; else printf "0.000000" }' "$saida_tmp")
        printf '%s\t%s\t%s\n' "$repeticao" "$media_io" "$media_cpu" >> "$dir/resumo.txt"
        total_io=$(awk -v a="$total_io" -v b="$media_io" 'BEGIN { printf "%.6f", a + b }')
        total_cpu=$(awk -v a="$total_cpu" -v b="$media_cpu" 'BEGIN { printf "%.6f", a + b }')
        cont_io=$(awk -v a="$cont_io" 'BEGIN { printf "%d", a + 1 }')
        cont_cpu=$(awk -v a="$cont_cpu" 'BEGIN { printf "%d", a + 1 }')
        rm -f "$saida_tmp"
        repeticao=$(expr "$repeticao" + 1)
    done
    media_final_io=$(awk -v a="$total_io" -v b="$cont_io" 'BEGIN { if (b > 0) printf "%.6f", a / b; else printf "0.000000" }')
    media_final_cpu=$(awk -v a="$total_cpu" -v b="$cont_cpu" 'BEGIN { if (b > 0) printf "%.6f", a / b; else printf "0.000000" }')
    printf '\nmedia_final\t%s\t%s\n' "$media_final_io" "$media_final_cpu" >> "$dir/resumo.txt"
done

exit 0
