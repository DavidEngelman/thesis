from env import *
import sys



# controller = LLVMController("c_examples/dummy2.ll")
# print(controller.llvm_file)

filepath = sys.argv[1]

env = LLVMEnv(filepath)
n_state = env.reset()


for i in range(1000000):
    if i % 100 == 0:
        print(i)
    done = False
    n_state = env.reset()
    while not done:
        # env.render()
        action = env.action_space.sample()
        n_state, reward, done, _ = env.step(action)



#env.render()
