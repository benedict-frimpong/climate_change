import numpy as np


def mastersetgeneration(data, anchors):
  """
  Generates two sets of trend differences based on anchor points.

  Args:
    data: A numpy array containing the data points.
    anchors: A numpy array with anchor points, each row containing (index, flag).
      - index: Index of the data point in the data array.
      - flag: 1 for increasing trend, 2 for decreasing trend.

  Returns:
    mastersetA: A numpy array containing trend differences for increasing trends.
    mastersetB: A numpy array containing trend differences for decreasing trends.
    setwidth: A list containing the number of data points in each trend.
  """

  anchor_size = len(anchors)

  # Initialize arrays
  mastersetA = np.zeros((2000, 12))
  mastersetB = np.zeros((2000, 12))
  setwidth = [0] * anchor_size

  k1 = 0
  k2 = 0

  for i in range(anchor_size):
    flag = anchors[i][1]
    if flag == 1:
      next_index = anchors[i + 1][0] if i < anchor_size - 1 else len(data)
      setwidth[i] = next_index - anchors[i][0] + 1
      for m in range(1, setwidth[i] + 1):
        if m == 1:
          mastersetA[k1, m - 1] = 0
        else:
          mastersetA[k1, m - 1] = data[anchors[i][0] + m - 2] - data[anchors[i][0] - 1]
      k1 += 1
    elif flag == 2:
      next_index = anchors[i + 1][0] if i < anchor_size - 1 else len(data)
      setwidth[i] = next_index - anchors[i][0] + 1
      for m in range(1, setwidth[i] + 1):
        if m == 1:
          mastersetB[k2, m - 1] = 0
        else:
          mastersetB[k2, m - 1] = data[anchors[i][0] + m - 2] - data[anchors[i][0] - 1]
      k2 += 1

  # Reduce arrays to actual length
  mastersetA = mastersetA[:k1]
  mastersetB = mastersetB[:k2]

  return mastersetA, mastersetB, setwidth

