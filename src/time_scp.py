import subprocess

print("sending")
subprocess.run(["sshpass", "-p", "qwertyuiop", "scp", "../c_examples/pi.c", "ubuntu@qzdqd7:/home/ubuntu/"])
print("done")