import argparse
import os
import sys

import gym
import numpy as np
import tensorflow as tf

# from stable_baselines.results_plotter import load_results, ts2xy
import stable_baselines
from stable_baselines import DQN, PPO2
from stable_baselines.bench import Monitor
from stable_baselines.common.env_checker import check_env
from stable_baselines.common.policies import MlpPolicy
from stable_baselines.deepq.policies import FeedForwardPolicy
from stable_baselines.common.vec_env import DummyVecEnv
from stable_baselines.common.callbacks import BaseCallback

from .env import LLVMEnv

import linecache
import os
import tracemalloc


class TensorboardCallback(BaseCallback):
    """
    Custom callback for plotting additional values in tensorboard.
    """
    def __init__(self, verbose=0):
        self.is_tb_set = False
        super(TensorboardCallback, self).__init__(verbose)

    def _on_step(self) -> bool:
            # value = 1
            # print(self.model.ep_info_buf)
            # summary = tf.Summary(value=[tf.Summary.Value(tag='run_time', simple_value=value)])
            # self.locals['writer'].add_summary(summary, self.num_timesteps)
        return True


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

    args = parser.parse_args()

    # Create and wrap the environment
    env = LLVMEnv(
                    args.filepath, 
                    timer=args.timer, 
                    onehot=args.onehot, 
                    reward_scaler=args.r_scaler,
                    op_age=args.op_age
                )


    check_env(env, warn=True)

    filename = args.filepath.split("/")[-1].split(".")[0]
    exp_name = f"{filename}_{args.algo}_oh_{str(args.onehot)}"

    log_file = 'logs/'
    if args.nolog:
        log_file = None
    

    if args.algo == "dqn":
        env = DummyVecEnv([lambda: env])
        model = DQN(CustomDQNPolicy, env, gamma=0.999, prioritized_replay=True, verbose=1, tensorboard_log=log_file)

    elif args.algo == "ppo":
        env = DummyVecEnv([lambda: env]*16)
        model = PPO2(MlpPolicy, env, gamma=0.999, n_steps=150, noptepochs=5, tensorboard_log=log_file)

    print("model created")

    # Train the agent
    time_steps = int(args.steps)
    print(time_steps)
    model.learn(total_timesteps=int(time_steps), tb_log_name=exp_name, callback=TensorboardCallback())




if __name__ == "__main__":
    main()
