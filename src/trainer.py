import argparse
import os
import sys
import numpy as np
import gym
import numpy as np
import tensorflow as tf
from .helper import parallelize, saveComplexJson
from pathlib import Path


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

import os
import json


TOTAL_RUNS = 10



# for dqn
class CustomDQNPolicy(FeedForwardPolicy):
    def __init__(self, *args, **kwargs):
        super(CustomDQNPolicy, self).__init__(*args, **kwargs,
                                           layers=[128],
                                           layer_norm=False,
                                           feature_extraction="mlp")


# for ppo
class CustomPolicy(stable_baselines.common.policies.FeedForwardPolicy):
    def __init__(self, *args, **kwargs):
        super(CustomPolicy, self).__init__(*args, **kwargs,
            net_arch=[dict(pi=[128], vf=[128])],
            feature_extraction="mlp")



def train(model, env, episodes):

    learning_stats = {
                        "ep_rewards": np.zeros(episodes),
                        "avg_ep_rewards": np.zeros(episodes),
                        "run_time": np.zeros(episodes),
                        "avg_run_time": np.zeros(episodes)
                     }


    avg_ep_rewards = 0
    avg_run_time = 0

    obs = env.reset()
    done = False

    for i in range(episodes):
        while not done:
            action, _states = model.predict(obs)
            obs, reward, done, info = env.step(action)

        avg_ep_rewards*= 0.95
        avg_ep_rewards += 0.05 * reward
        run_time = info["run_time"]
        avg_run_time*=0.95
        avg_run_time += 0.05 * run_time

        learning_stats["ep_rewards"][i] = reward
        learning_stats["avg_ep_rewards"][i] = avg_ep_rewards
        learning_stats["run_time"][i] = run_time
        learning_stats["avg_run_time"][i] = avg_run_time
    
    if i % 50 == 0:
            print(f"Episode {i}: avg ep reward: {avg_ep_rewards} -- avg run time: {avg_run_time}")


    return learning_stats

def add_job(jobs, pool):
    for i in range(TOTAL_RUNS):

        jobs[(exp_name, i)] = pool.apply_async(train, (model, env, total_episodes))




if __name__ == "__main__":

    parser = argparse.ArgumentParser()
    parser.add_argument('--filepath', help='program filepath to optimize', required=True)
    parser.add_argument('--algo', help='The RL algorithm', default="dqn", choices=["dqn", "ppo"])
    parser.add_argument('--episodes', help='Number of episodes for training', default=1000, type=float)
    parser.add_argument('--timer', help='timer function to be used by the env', 
                        default="timer_v1")
    parser.add_argument('--r-scaler', help='constant to rescale de reward', default=10, type=int)
    parser.add_argument('--op-age', help='extremum function to be used for the age of the operands',
                        default=min)
    parser.add_argument('--onehot', help='if true,  onehot encode the operand in the state', 
                        action='store_true', default=False)
    parser.add_argument('--nolog', action='store_true', default=False)
    parser.add_argument('--nb_processes', default=4, type=int)


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


    Path("results/").mkdir(parents=True, exist_ok=True)

    
    if args.algo == "dqn":
        # env = DummyVecEnv([lambda: env])
        model = DQN(CustomDQNPolicy, env, gamma=0.999, prioritized_replay=True)

    elif args.algo == "ppo":
        env = DummyVecEnv([lambda: env]*16)
        model = PPO2(MlpPolicy, env, gamma=0.999, n_steps=150, noptepochs=5)

    print("model created")
    
    total_episodes = args.episodes
    learning_stats = train(model, env, 5000)
    with open(f'{exp_name}.json', 'w') as fp:
        json.dump(learning_stats, fp)

