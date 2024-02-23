import numpy as np

def minmaxanchors(data):
  """
  Finds minimum and maximum points as anchors in a given data array.

  Args:
    data: A numpy array containing the data points.

  Returns:
    anchors: A numpy array containing anchor points (index, flag, value).
      - index: Index of the anchor point in the data array.
      - flag: 1 for minimum, 2 for maximum.
      - value: Value of the data point at the anchor point.
    anchor1data: A numpy array containing minimum points (value, index).
    anchor2data: A numpy array containing maximum points (value, index).
  """

  # Initialize arrays
  data_size = len(data)
  anchors = np.zeros((2000, 3))
  anchor1data = np.zeros((2000, 2))
  anchor2data = np.zeros((2000, 2))

  j = 0
  j1 = 0
  j2 = 0

  # Iterate through data points (starting from 3rd element)
  for i in range(2, data_size):
    prev1, prev2, curr = data[i - 2], data[i - 1], data[i]

    # Check for minimum
    if curr > prev1 and prev1 < prev2:
      anchors[j, 0] = i - 1
      anchors[j, 1] = 1  # Flag for minimum
      anchors[j, 2] = curr
      anchor1data[j1, 0] = curr
      anchor1data[j1, 1] = i - 1
      data[i - 1, 2] = j  # Mark data point as anchor
      j += 1
      j1 += 1
    elif curr == prev1 and prev1 < prev2:  # Zero slope, check previous point
      if i >= 4 and prev2 > prev1:
        anchors[j, 0] = i - 1
        anchors[j, 1] = 1
        anchors[j, 2] = curr
        anchor1data[j1, 0] = curr
        anchor1data[j1, 1] = i - 1
        data[i - 1, 2] = j
        j += 1
        j1 += 1

    # Check for maximum
    elif curr < prev1 and prev1 > prev2:
      anchors[j, 0] = i - 1
      anchors[j, 1] = 2  # Flag for maximum
      anchors[j, 2] = curr
      anchor2data[j2, 0] = curr
      anchor2data[j2, 1] = i - 1
      data[i - 1, 2] = j
      j += 1
      j2 += 1
    elif curr == prev1 and prev1 > prev2:  # Zero slope, check previous point
      if i >= 4 and prev2 < prev1:
        anchors[j, 0] = i - 1
        anchors[j, 1] = 2
        anchors[j, 2] = curr
        anchor2data[j2, 0] = curr
        anchor2data[j2, 1] = i - 1
        data[i - 1, 2] = j
        j += 1
        j2 += 1

  # Reduce arrays to actual length
  anchors = anchors[:j]
  anchor1data = anchor1data[:j1]
  anchor2data = anchor2data[:j2]

  return anchors, anchor1data, anchor2data

