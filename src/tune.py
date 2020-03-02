from env import *
import sys



# controller = LLVMController("c_examples/dummy2.ll")
# print(controller.llvm_file)

# filepath = sys.argv[1]
filepath = "../c-ray/c-ray-f-2.ll"
# filepath = "../c_examples/dummy2.ll"
#filepath = "../c_examples/factorial.ll"

env = LLVMEnv(filepath)

for _ in range(1):
    n_state = env.reset()
    done = False
    while not done:
        env.render()
        action = env.action_space.sample()
        action = 0
        n_state, reward, done, _ = env.step(action)
    env.render()
