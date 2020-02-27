from stable_baselines.common.env_checker import check_env
from stable_baselines.common.vec_env import DummyVecEnv, VecNormalize

from env import *
import os
import sys
import gym
import numpy as np
import matplotlib.pyplot as plt

# from stable_baselines.ddpg.policies import LnMlpPolicy
from stable_baselines.bench import Monitor
from stable_baselines.results_plotter import load_results, ts2xy
from stable_baselines import DQN, ACER
# from stable_baselines.ddpg import AdaptiveParamNoiseSpec
from stable_baselines import results_plotter

# controller = LLVMController("c_examples/dummy2.ll")
# print(controller.llvm_file)

filepath = sys.argv[1]

best_mean_reward, n_steps = -np.inf, 0


# def callback(_locals, _globals):
#     """
#     Callback called at each step (for DQN an others) or after n steps (see ACER or PPO2)
#     :param _locals: (dict)
#     :param _globals: (dict)
#     """
#     global n_steps, best_mean_reward
#     # Print stats every 1000 calls
#     if (n_steps + 1) % 1000 == 0:
#         # Evaluate policy training performance
#         x, y = ts2xy(load_results(log_dir), 'timesteps')
#         if len(x) > 0:
#             mean_reward = np.mean(y[-100:])
#             print(x[-1], 'timesteps')
#             print(
#                 "Best mean reward: {:.2f} - Last mean reward per episode: {:.2f}".format(best_mean_reward, mean_reward))
#
#             # New best model, you could save the agent here
#             if mean_reward > best_mean_reward:
#                 best_mean_reward = mean_reward
#                 # Example for saving best model
#                 print("Saving new best model")
#                 _locals['self'].save(log_dir + 'best_model.pkl')
#     n_steps += 1
#     return True


# Create log dir
log_dir = "tmp/"
plot_dir = "plot/"
os.makedirs(log_dir, exist_ok=True)
os.makedirs(plot_dir, exist_ok=True)

# Create and wrap the environment
env = LLVMEnv(filepath)
check_env(env, warn=True)
env = Monitor(env, log_dir)
env = DummyVecEnv([lambda: env])

# peut etre utile
# env = VecNormalize(env, norm_obs=True, norm_reward=False)




model = DQN('MlpPolicy', env, prioritized_replay=True, verbose=1, tensorboard_log="./logs/")
# Train the agent
time_steps = 1e5
model.learn(total_timesteps=int(time_steps), tb_log_name="DQN")

# model = ACER('MlpPolicy', env, verbose=1, tensorboard_log="./logs/")
# # Train the agent
# time_steps = 1e5
# model.learn(total_timesteps=int(time_steps), tb_log_name="ACER")

# results_plotter.plot_results([log_dir], time_steps, results_plotter.X_TIMESTEPS, "DQN LLVMEnv")
# plt.savefig(plot_dir + "dqn.png")

