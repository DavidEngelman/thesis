from env import *
import sys



# controller = LLVMController("c_examples/dummy2.ll")
# print(controller.llvm_file)

# filepath = sys.argv[1]
filepath = "../c-ray/c-ray-f-2.ll"

env = LLVMEnv(filepath)
n_state = env.reset()
done = False
while not done:
    #env.render()
    action = env.action_space.sample()
    n_state, reward, done, _ = env.step(action)



#env.render()
