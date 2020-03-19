# import stable_baselines
# import gym
# import sys

# NUM_ENVS = 16
# SEED = int(sys.argv[2])
# ALGO = sys.argv[1]

# class CustomPolicy(stable_baselines.common.policies.FeedForwardPolicy):
#     def __init__(self, *args, **kwargs):
#         super(CustomPolicy, self).__init__(*args, **kwargs,
#             net_arch=[dict(pi=[128], vf=[128])],
#             feature_extraction="mlp")

# def make_env():
#     return gym.make('EnvName-v0')

# env = stable_baselines.common.make_vec_env(make_env, n_envs=NUM_ENVS)

# if ALGO == 'ppo':
#     model = stable_baselines.PPO2(CustomPolicy, env, gamma=0.999, n_steps=150, noptepochs=5, n_cpu_tf_sess=1, tensorboard_log='/tmp/multisensors-acktr-1', seed=SEED)
# elif ALGO == 'acktr':
#     model = stable_baselines.ACKTR(CustomPolicy, env, gamma=0.999, n_steps=150, n_cpu_tf_sess=1, tensorboard_log='/tmp/multisensors-acktr-1', seed=SEED)
# elif ALGO == 'dqn':
#     # Même chose pour DQN, même si PPO apprend mieux généralement que DQN

# # model.learn(1000000)
