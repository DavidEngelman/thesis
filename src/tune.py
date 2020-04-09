import argparse
from .env import *
import pickle




parser = argparse.ArgumentParser()
parser.add_argument('--filepath', help='program filepath to optimize', required=True)
parser.add_argument('--algo', help='The RL algorithm', default="dqn", choices=["dqn", "ppo"])
parser.add_argument('--steps', help='Number of steps for training', default=1e5, type=float)
parser.add_argument('--timer', help='timer function to be used by the env', 
                    default="timer_v1")
parser.add_argument('--r-scaler', help='constant to rescale de reward', default=10, type=int)
parser.add_argument('--op-age', help='extremum function to be used for the age of the operands',
                    default=min)
parser.add_argument('--onehot', help='if true,  onehot encode the operand in the state', 
                    action='store_true', default=False)
parser.add_argument('--nolog', action='store_true', default=False)
parser.add_argument('--save', action='store_true', default=False, help='save the ".ll" file')
parser.add_argument('--remote', action='store_true', default=False)
parser.add_argument('--noage', action='store_false', default=True)




args = parser.parse_args()

# Create and wrap the environment
env = LLVMEnv(
        args.filepath, 
        timer=args.timer, 
        onehot=args.onehot, 
        reward_scaler=args.r_scaler,
        op_age=args.op_age,
        save_ll=args.save,
        remote=args.remote,
        with_age=args.noage
    )

times = {"min": [], "mean": [], "std": []}
for i in range(1000):
    print(i)
    n_state = env.reset()
    done = False
    while not done:
        action = env.action_space.sample()
        n_state, reward, done, info = env.step(action)
        
    
    times["min"].append(info["episode"]["run_time"][0])
    times["mean"].append(info["episode"]["run_time"][1])
    times["std"].append(info["episode"]["run_time"][2])

print(times)
pickle.dump(times, open("cray_pi_100000", "wb"))
