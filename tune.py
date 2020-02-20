from env import *
import sys

# controller = LLVMController("c_examples/dummy2.ll")
# print(controller.llvm_file)

filepath = sys.argv[1]

env = LLVMEnv(filepath)
n_state = env.reset()

done = False
#env.render()

while not done:
    #env.render()
    n_state, reward, done = env.step(0)
    

#env.render()
