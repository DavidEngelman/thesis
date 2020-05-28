import argparse
import os
import sys
from pathlib import Path

import gym
import numpy as np
import tensorflow as tf

# from stable_baselines.results_plotter import load_results, ts2xy
import stable_baselines
from stable_baselines.bench import Monitor
from stable_baselines.common.env_checker import check_env
from stable_baselines.common.policies import MlpPolicy, MlpLstmPolicy
from stable_baselines.deepq.policies import FeedForwardPolicy
from stable_baselines.common.vec_env import DummyVecEnv
from stable_baselines.common.callbacks import BaseCallback
from stable_baselines.common.callbacks import CheckpointCallback

from stable_baselines import PPO2


from .env import LLVMEnv
from .ppo2 import CustomPPO2
from .dqn import CustomDQN


import os



class CustomDQNPolicy(FeedForwardPolicy):
    def __init__(self, *args, **kwargs):
        super(CustomDQNPolicy, self).__init__(*args, **kwargs,
                                           layers=[128],
                                           layer_norm=False,
                                           feature_extraction="mlp")



class CustomPolicy(stable_baselines.common.policies.FeedForwardPolicy):
    def __init__(self, *args, **kwargs):
        super(CustomPolicy, self).__init__(*args, **kwargs,
            net_arch=[dict(pi=[128], vf=[128])],
            feature_extraction="mlp")

def main():

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
    parser.add_argument('--load', default=None,
                          help='load a model to resume training')




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


    check_env(env, warn=True)

    filename = args.filepath.split("/")[-1].split(".")[0]
    exp_name = f"{filename}_{args.algo}_oh_{str(args.onehot)}"

    log_file = args.algo
    if args.nolog:
        log_file = None
    

    if args.algo == "dqn":
        env = DummyVecEnv([lambda: env])
        model = CustomDQN(CustomDQNPolicy, env, gamma=0.999, prioritized_replay=True, verbose=1)

    elif args.algo == "ppo":
        print("creating model...")
        env = DummyVecEnv([lambda: env]*8)
        model = PPO2(MlpLstmPolicy, env, gamma=0.999, n_steps=1000, noptepochs=5, verbose=2, learning_rate=1e-4)
        print("done")



    checkpoint_callback = CheckpointCallback(save_freq=10000, save_path='./checkpoints',
                                         name_prefix=exp_name)
 

    print("model created")

    # Train the agent
    time_steps = int(args.steps)
    print(time_steps)
    model.learn(total_timesteps=int(time_steps), callback=checkpoint_callback)

    




if __name__ == "__main__":
    main()
