---
title: Find max subarray
tags: [Alogorithms, Ruby]
---

<p class="lead">
算法导论，查找最大子数组, 分治策略ruby实现。
</p>

```ruby
def find_max_crossing_subarray(array, low, mid, high)
  left_sum = -Float::INFINITY
  sum = 0

  for i in mid.downto(low)
    sum += array[i]
    if sum > left_sum
      left_sum = sum
      max_left = i
    end
  end
  right_sum = -Float::INFINITY
  sum = 0

  for i in mid.upto(high)
    sum += array[i]
    if sum > right_sum
      right_sum = sum
      max_right = i
    end
  end

  [max_left, max_right, left_sum + right_sum]
end

def find_max_subarray(array, low, high)
  if low == high
    return [low, high, array[low]]
  else mid=(low + high)/2
    left_low, left_high, left_sum    = find_max_subarray(array, low, mid)
    right_low, right_high, right_sum = find_max_subarray(array, mid+1, high)
    cross_low, cross_high, cross_sum = find_max_crossing_subarray(array, low, mid, high)

    if left_sum >= right_sum and left_sum >= cross_sum
      return left_low, left_high, left_sum
    elsif cross_sum >= left_sum and cross_sum >= right_sum
      return cross_low, cross_high, cross_sum
    elsif right_sum >= cross_sum and right_sum >= left_sum
      return right_low, right_high, right_sum
    end
  end
end

array = [1,2,3,4,-11,8,6,7,-19,8,9,-8,1,10]
p find_max_subarray(array, 0, array.size-1)
```
