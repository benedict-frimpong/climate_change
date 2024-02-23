import pandas as pd
import numpy as np

# Read data from CSV file
waterlevel = pd.read_csv("CO-OPS__8594900__hr.csv", header=None).iloc[1:, 0].values

# Calculate baseline and mass balance
baseline = np.mean(waterlevel)
mass_balance = np.sum(waterlevel - baseline)

# Find anchor points
anchors = np.zeros(len(waterlevel))
for i in range(1, len(waterlevel)):
    if waterlevel[i-1] <= baseline and waterlevel[i] > baseline:
        # Negative to positive shift (type 1 anchor)
        anchors[i] = 1
    elif waterlevel[i-1] >= baseline and waterlevel[i] < baseline:
        # Positive to negative shift (type 2 anchor)
        anchors[i] = 2

# Analyze type 1 anchors
type1_anchors = np.where(anchors == 1)[0]
mass_balance_type1 = np.zeros(len(type1_anchors))
total_mass_type1 = np.zeros((len(type1_anchors), 4))
for i in range(1, len(type1_anchors)):
    data_segment = waterlevel[type1_anchors[i-1]:type1_anchors[i]]
    mass_balance_type1[i] = np.mean(data_segment - baseline)
    total_mass_type1[i, 0] = np.sum(np.abs(data_segment - baseline) ** 2)
    total_mass_type1[i, 1] = type1_anchors[i-1]
    total_mass_type1[i, 2] = type1_anchors[i]
    total_mass_type1[i, 3] = np.sum(data_segment - baseline)

# Further analysis (optional):
# ... you can implement analysis of type 2 anchors or moving averages using similar techniques

# Print or visualize results as needed
print(f"Mass balance for all data: {mass_balance}")
print(f"Number of type 1 anchors: {len(type1_anchors)}")
print(f"Average mass balance for type 1 anchors: {np.mean(mass_balance_type1)}")

# Example: visualize mass balance for type 1 anchors
import matplotlib.pyplot as plt
plt.plot(type1_anchors, mass_balance_type1)
plt.xlabel("Anchor Index")
plt.ylabel("Mass Balance")
plt.title("Mass Balance for Type 1 Anchors")
plt.show()
