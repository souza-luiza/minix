/* This table has one slot per process.  It contains scheduling information
 * for each process.
 */
#include <limits.h>

#include <minix/bitmap.h>

/* EXTERN should be extern except in main.c, where we want to keep the struct */
#ifdef _MAIN
#undef EXTERN
#define EXTERN
#endif

#ifndef CONFIG_SMP
#define CONFIG_MAX_CPUS 1
#endif

/**
 * We might later want to add more information to this table, such as the
 * process owner, process group or cpumask.
 */

/* Scheduling queue definitions for lottery scheduling
 * The kernel's priority queue system is used to manage lottery state
 * safely within the 16 native queues of Minix 3.4:
 * - Queues 0-12: Standard MINIX system priority queues
 * - Queue 13 (MAX_USER_Q): Lottery winner, runs with full quantum
 * - Queue 14 (USER_Q): User processes awaiting lottery selection
 * - Queue 15 (MIN_USER_Q): Minimum user priority
 */

#define MAX_USER_Q  13  /* Vencedor da loteria corre aqui */
#define USER_Q      14  /* Processos esperando loteria */
#define MIN_USER_Q  15  /* Fila minima */

EXTERN struct schedproc {
  endpoint_t endpoint;  /* process endpoint id */
  endpoint_t parent;    /* parent endpoint id */
  unsigned flags;   /* flag bits */

  /* User space scheduling */
  unsigned max_priority;  /* this process' highest allowed priority */
  unsigned priority;    /* the process' current priority */
  unsigned time_slice;    /* this process's time slice */
  unsigned cpu;   /* what CPU is the process running on */
  unsigned ticketsNum;    /* numero de bilhetes q cada processo tem */
  
  bitchunk_t cpu_mask[BITMAP_CHUNKS(CONFIG_MAX_CPUS)]; /* what CPUs is the
                process allowed
                to run on */
} schedproc[NR_PROCS];

/* Flag values */
#define IN_USE    0x00001 /* set when 'schedproc' slot in use */