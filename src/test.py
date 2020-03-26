import subprocess, resource, os
import numpy as np

subprocess.run(["clang-7", "-O0", "-o", "res", "../c-ray/c-ray-f-2.ll", "-lm"])

pid = os.getpid()
os.sched_setaffinity(pid, {0})

for i in range(1):
    times = []
    for i in range(10):
        usage_start = resource.getrusage(resource.RUSAGE_CHILDREN)
        subprocess.run(["./res"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        usage_end = resource.getrusage(resource.RUSAGE_CHILDREN)
        times.append(usage_end.ru_utime - usage_start.ru_utime)
    print(f"min time: {min(times[1:])}")
    print(f"avg time: {np.mean(times[1:])}")
    print('------')
