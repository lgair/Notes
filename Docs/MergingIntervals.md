# Common Availability Among Multiple Friends

## Problem Statement

Given a list of schedules, where each friend's schedule is represented as a list of intervals indicating when they are available, find the common available times for all friends.

### Input Example

- Friend 1: `[[1, 3], [5, 6], [7, 8]]`
- Friend 2: `[[2, 4], [5, 7]]`
- Friend 3: `[[1, 2], [5, 8]]`

### Expected Output

- Common availability: `[[5, 6]]`

## Steps to Solve

1. **Merge Intervals for Each Friend**: Ensure each friend's intervals are merged if needed.
2. **Find Common Intervals**:
   - Start with the first friend's intervals as the base.
   - Iterate through the subsequent friends, finding the intersection of the current common intervals with each friend's intervals.

### Merging Intervals

Merging intervals is a crucial step to simplify the problem before finding common availability. The merging process involves the following steps:

1. **Sort the Intervals**: Begin by sorting each friend's intervals based on the start times.
2. **Iterate and Merge**: Traverse the sorted intervals and merge them:
   - If an interval overlaps with the last added interval in the merged list (i.e., if the start of the current interval is less than or equal to the end of the last merged interval), extend the last merged interval's end to the maximum of both ends.
   - If there is no overlap, add the current interval to the list of merged intervals.

### Example of Merging Intervals

For Friend 1's intervals `[[1, 3], [5, 6], [7, 8]]`:

1. Sort: Already sorted.
2. Merge:
   - Start with the first interval: `[1, 3]`.
   - Next interval `[5, 6]` does not overlap, so add it: `[1, 3], [5, 6]`.
   - Next interval `[7, 8]` does not overlap, so add it: `[1, 3], [5, 6], [7, 8]`.

This results in the merged intervals `[[1, 3], [5, 6], [7, 8]]`.

## Time Complexity

- **Merging Intervals**:
  - **Sorting**: O(n log n) for each friend's list (where n is the number of intervals).
  - **Merging**: O(n) for each friend.
  
  Therefore, for `k` friends, we have:
  
  \[
  O(k \cdot m \log m)
  \]

  (where `m` is the average number of intervals per friend).

- **Finding Common Intervals**: 
  Each intersection will take linear time in terms of the number of intervals, so:
  
  \[
  O(t) \quad (\text{where } t \text{ is total merged intervals})
  \]

Combining gives:

\[
O(k \cdot m \log m)
\]

## Space Complexity

- **Storage for Merged Intervals**: 
  At most `k * m` for storing merged intervals.
  
  \[
  O(k \cdot m)
  \]

## C++ Code Example

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

// Function to merge intervals for each friend's schedule
vector<pair<int, int>> mergeIntervals(vector<pair<int, int>>& intervals) {
    if (intervals.empty()) return {};
    
    sort(intervals.begin(), intervals.end());
    vector<pair<int, int>> merged;
    
    for (const auto& interval : intervals) {
        if (merged.empty() || merged.back().second < interval.first) {
            merged.push_back(interval);
        } else {
            merged.back().second = max(merged.back().second, interval.second);
        }
    }
    return merged;
}

// Function to intersect two lists of intervals
vector<pair<int, int>> intersectIntervals(const vector<pair<int, int>>& A, const vector<pair<int, int>>& B) {
    vector<pair<int, int>> result;
    int i = 0, j = 0;
    
    while (i < A.size() && j < B.size()) {
        // Check for overlap
        int start = max(A[i].first, B[j].first);
        int end = min(A[i].second, B[j].second);
        
        if (start < end) {
            result.push_back({start, end});
        }

        // Move to the interval that ends first
        if (A[i].second < B[j].second) {
            i++;
        } else {
            j++;
        }
    }
    return result;
}

// Main function to find common availability
vector<pair<int, int>> findCommonAvailability(const vector<vector<pair<int, int>>>& schedules) {
    // Merge intervals for each friend's schedule
    vector<vector<pair<int, int>>> mergedSchedules;
    
    for (const auto& schedule : schedules) {
        mergedSchedules.push_back(mergeIntervals(schedule));
    }
    
    vector<pair<int, int>> common = mergedSchedules[0];
    
    // Intersect with each friend's availability
    for (size_t i = 1; i < mergedSchedules.size(); i++) {
        common = intersectIntervals(common, mergedSchedules[i]);
    }
    
    return common;
}

// Test the function
int main() {
    vector<vector<pair<int, int>>> schedules = {
        {{1, 3}, {5, 6}, {7, 8}},
        {{2, 4}, {5, 7}},
        {{1, 2}, {5, 8}}
    };
    
    vector<pair<int, int>> commonAvailability = findCommonAvailability(schedules);
    
    cout << "Common Availability:\n";
    for (const auto& interval : commonAvailability) {
        cout << "[" << interval.first << ", " << interval.second << "] ";
    }
    return 0;
}
```
