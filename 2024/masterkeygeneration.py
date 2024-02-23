import numpy as np

def masterkeygeneration(data, anchors, mastersetA, mastersetB, setwidth):
  """
  Generates two master keys based on trend differences and widths.

  Args:
    data: A numpy array containing the data points.
    anchors: A numpy array with anchor points, each row containing (index, flag).
      - index: Index of the data point in the data array.
      - flag: 1 for increasing trend, 2 for decreasing trend.
    mastersetA: A numpy array containing trend differences for increasing trends.
    mastersetB: A numpy array containing trend differences for decreasing trends.
    setwidth: A list containing the number of data points in each trend.

  Returns:
    masterkeyA: A numpy array representing the master key for increasing trends.
    masterkeyB: A numpy array representing the master key for decreasing trends.
  """

  anchor_size = len(anchors)

  # Initialize arrays
  masterkeyA = np.zeros((12, 12))
  masterkeyB = np.zeros((12, 12))
  countsA = np.zeros(12)
  countsB = np.zeros(12)

  k1 = 0
  k2 = 0

  for i in range(anchor_size):
    width = setwidth[i]
    if width <= 12:
      if anchors[i][1] == 1:
        k1 += 1
        countsA[width - 1] += 1
        masterkeyA[width - 1, :width] += mastersetA[k1 - 1, :width]
      elif anchors[i][1] == 2:
        k2 += 1
        countsB[width - 1] += 1
        masterkeyB[width - 1, :width] += mastersetB[k2 - 1, :width]

  # Create master key by averaging
  for i in range(12):
    for j in range(12):
      if countsA[i] > 0:
        masterkeyA[i, j] /= countsA[i]
      if countsB[i] > 0:
        masterkeyB[i, j] /= countsB[i]

  return masterkeyA, masterkeyB

