CC ?= cc
CFLAGS ?= -O2 -Wall -Wextra

IO_OPS = 10000
CPU_OPS = 10000000
REPETICOES = 5

QTDE_PROC_CENARIO_1 = 10
QTDE_PROC_CENARIO_2 = 50
QTDE_PROC_CENARIO_3 = 100
QTDE_PROC_CENARIO_4 = 200

CRIADOR_PROCESSOS = src/teste_processos.c
EXECUTAVEL = teste_processos
RESULTADOS = resultados

all: $(EXECUTAVEL)

$(EXECUTAVEL): $(CRIADOR_PROCESSOS)
	$(CC) $(CFLAGS) -o $@ $<

$(RESULTADOS):
	mkdir -p $@

run: $(EXECUTAVEL) $(RESULTADOS)
	chmod +x scripts/run_experimentos.sh
	./scripts/run_experimentos.sh "$(QTDE_PROC_CENARIO_1) $(QTDE_PROC_CENARIO_2) $(QTDE_PROC_CENARIO_3) $(QTDE_PROC_CENARIO_4)" $(IO_OPS) $(CPU_OPS) $(REPETICOES) $(EXECUTAVEL) $(RESULTADOS)

clean:
	rm -f $(EXECUTAVEL)
	rm -rf $(RESULTADOS)

.PHONY: all run clean
