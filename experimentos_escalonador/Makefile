CC ?= cc
CFLAGS ?= -O2 -Wall -Wextra

IO_OPS = 1000000
CPU_OPS = 100000000
REPETICOES = 5

QTDE_PROC_CENARIO_1 = 50
QTDE_PROC_CENARIO_2 = 100
QTDE_PROC_CENARIO_3 = 500
QTDE_PROC_CENARIO_4 = 1000

CRIADOR_PROCESSOS = src/teste_processos.c
EXECUTAVEL = teste_processos
RESULTADOS = resultados

all: $(EXECUTAVEL)

$(EXECUTAVEL): $(CRIADOR_PROCESSOS)
	$(CC) $(CFLAGS) -o $@ $<

$(RESULTADOS):
	mkdir -p $@

run: $(EXECUTAVEL) $(RESULTADOS)
	@for qtde in $(QTDE_PROC_CENARIO_1) $(QTDE_PROC_CENARIO_2) $(QTDE_PROC_CENARIO_3) $(QTDE_PROC_CENARIO_4); do \
		dir="$(RESULTADOS)/cenario_$$qtde"; \
		mkdir -p "$$dir"; \
		printf 'cenario=%s\nio_ops=%s\ncpu_ops=%s\nrepeticoes=%s\n\nexecucao\tmedia_io\tmedia_cpu\n' "$$qtde" "$(IO_OPS)" "$(CPU_OPS)" "$(REPETICOES)" > "$$dir/resumo.txt"; \
		total_io=0; \
		total_cpu=0; \
		cont_io=0; \
		cont_cpu=0; \
		repeticao=1; \
		while [ "$$repeticao" -le $(REPETICOES) ]; do \
			stdout="$$dir/exec_$$repeticao.stdout"; \
			stderr="$$dir/exec_$$repeticao.stderr"; \
			printf 'execucao=%s\n' "$$repeticao" > "$$stdout"; \
			./$(EXECUTAVEL) $$qtde $(IO_OPS) $(CPU_OPS) >> "$$stdout" 2> "$$stderr"; \
			media_io=$$(awk '/^IO[[:space:]]/ { soma += $$3; contador += 1 } END { if (contador > 0) printf "%.6f", soma / contador; else printf "0.000000" }' "$$stdout"); \
			media_cpu=$$(awk '/^CPU[[:space:]]/ { soma += $$3; contador += 1 } END { if (contador > 0) printf "%.6f", soma / contador; else printf "0.000000" }' "$$stdout"); \
			printf '%s\t%s\t%s\n' "$$repeticao" "$$media_io" "$$media_cpu" >> "$$dir/resumo.txt"; \
			total_io=$$(awk -v a="$$total_io" -v b="$$media_io" 'BEGIN { printf "%.6f", a + b }'); \
			total_cpu=$$(awk -v a="$$total_cpu" -v b="$$media_cpu" 'BEGIN { printf "%.6f", a + b }'); \
			cont_io=$$(awk -v a="$$cont_io" 'BEGIN { printf "%d", a + 1 }'); \
			cont_cpu=$$(awk -v a="$$cont_cpu" 'BEGIN { printf "%d", a + 1 }'); \
			repeticao=$$(($$repeticao + 1)); \
		done; \
		media_final_io=$$(awk -v a="$$total_io" -v b="$$cont_io" 'BEGIN { if (b > 0) printf "%.6f", a / b; else printf "0.000000" }'); \
		media_final_cpu=$$(awk -v a="$$total_cpu" -v b="$$cont_cpu" 'BEGIN { if (b > 0) printf "%.6f", a / b; else printf "0.000000" }'); \
		printf '\nmedia_final\t%s\t%s\n' "$$media_final_io" "$$media_final_cpu" >> "$$dir/resumo.txt"; \
	done

clean:
	rm -f $(EXECUTAVEL)
	rm -rf $(RESULTADOS)

.PHONY: all run clean
