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
parser.add_argument('--ip', default=None, type=str)
parser.add_argument('--noage', action='store_false', default=True)




args = parser.parse_args()

if args.remote and args.ip == None:
    print("please use --ip to specify the address of the remote device")
    exit()

if not(args.remote) and  args.ip:
    print("WARNING: if you want to time the program in the remote device please add --remote")

# Create and wrap the environment
env = LLVMEnv(
        args.filepath, 
        timer=args.timer, 
        onehot=args.onehot, 
        reward_scaler=args.r_scaler,
        op_age=args.op_age,
        save_ll=args.save,
        remote=args.remote,
        with_age=args.noage,
        ip_address=args.ip
    )

res = {"min": [], "mean": [], "std": [], "r": [], "ts": [],}
for i in range(50):
    print(i)
    n_state = env.reset()
    done = False
    while not done:
        action = env.action_space.sample()
        n_state, reward, done, info = env.step(action)
        
    
    res["min"].append(info["episode"]["run_time"][0])
    res["mean"].append(info["episode"]["run_time"][1])
    res["std"].append(info["episode"]["run_time"][2])
    res["r"].append(reward)
    res["ts"].append(info["episode"]["l"])



pickle.dump(res, open("cray_c_benchmark_10_rpi_cpu_cycles_O0", "wb"))
