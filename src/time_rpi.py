NB_RUNS = 10

import os
import subprocess
import resource
import sys


subprocess.run([        "clang-9",
                        "-O0",
                        "-o", "res", 
                        sys.argv[1],
                        "-march=native",
                        "-mllvm", "-enable-misched=false",
                        "-lm",
                        ])

# time program
times = []

# select only one cpu
pid = os.getpid()
os.sched_setaffinity(pid, {0})
for _ in range(NB_RUNS):
    usage_start = resource.getrusage(resource.RUSAGE_CHILDREN)
    subprocess.run(["./res"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    usage_end = resource.getrusage(resource.RUSAGE_CHILDREN)
    times.append(usage_end.ru_utime - usage_start.ru_utime)

os.sched_setaffinity(pid, {0, 1, 2, 3})
print(min(times))