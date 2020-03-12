import argparse
import os
import sys

import gym
import numpy as np
# from stable_baselines.results_plotter import load_results, ts2xy
from stable_baselines import DQN
from stable_baselines.bench import Monitor
from stable_baselines.common.env_checker import check_env
from stable_baselines.deepq.policies import FeedForwardPolicy, MlpPolicy
from stable_baselines.common.vec_env import DummyVecEnv

from .env import LLVMEnv

import linecache
import os
import tracemalloc


class CustomDQNPolicy(FeedForwardPolicy):
    def __init__(self, *args, **kwargs):
        super(CustomDQNPolicy, self).__init__(*args, **kwargs,
                                           layers=[128],
                                           layer_norm=False,
                                           feature_extraction="mlp")

def main():

    parser = argparse.ArgumentParser()
    parser.add_argument('--filepath', help='program filepath to optimize', required=True)
    parser.add_argument('--algo', help='The RL algorithm', default="DQN")
    parser.add_argument('--steps', help='Number of steps for training', default=1e5, type=float)
    parser.add_argument('--timer', help='timer function to be used by the env', 
                        default="timer_v1")
    parser.add_argument('--r-scaler', help='constant to rescale de reward', default=10, type=int)
    parser.add_argument('--op-age', help='extremum function to be used for the age of the operands',
                        default=min)
    parser.add_argument('--onehot', help='if true,  onehot encode the operand in the state', 
                        action='store_true', default=False)

    args = parser.parse_args()

    # Create and wrap the environment
    env = LLVMEnv(
                    args.filepath, 
                    timer=args.timer, 
                    onehot=args.onehot, 
                    reward_scaler=args.r_scaler,
                    op_age=args.op_age
                )

    print("env created")


    check_env(env, warn=True)
    env = DummyVecEnv([lambda: env])
    filename = args.filepath.split("/")[-1].split(".")[0]
    exp_name = f"{filename}_{args.algo}_oh_{str(args.onehot)}"

    if args.algo == "DQN":
        model = DQN(CustomDQNPolicy, env, gamma=0.999, prioritized_replay=True, verbose=1, tensorboard_log="logs/")

    print("model created")

    # Train the agent
    time_steps = int(args.steps)
    print(time_steps)
    model.learn(total_timesteps=int(time_steps), tb_log_name=exp_name)


def display_top(snapshot, key_type='lineno', limit=10):
    snapshot = snapshot.filter_traces((
        tracemalloc.Filter(False, "<frozen importlib._bootstrap>"),
        tracemalloc.Filter(False, "<unknown>"),
    ))
    top_stats = snapshot.statistics(key_type)

    print("Top %s lines" % limit)
    for index, stat in enumerate(top_stats[:limit], 1):
        frame = stat.traceback[0]
        print("#%s: %s:%s: %.1f KiB"
              % (index, frame.filename, frame.lineno, stat.size / 1024))
        line = linecache.getline(frame.filename, frame.lineno).strip()
        if line:
            print('    %s' % line)

    other = top_stats[limit:]
    if other:
        size = sum(stat.size for stat in other)
        print("%s other: %.1f KiB" % (len(other), size / 1024))
    total = sum(stat.size for stat in top_stats)
    print("Total allocated size: %.1f KiB" % (total / 1024))

tracemalloc.start()

# ... run your application ...

snapshot = tracemalloc.take_snapshot()
display_top(snapshot)
if __name__ == "__main__":
    # tracemalloc.start()
    main()
    # snapshot = tracemalloc.take_snapshot()
    # display_top(snapshot)