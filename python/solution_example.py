# solution_example.py
# Placeholder Python solution

def two_sum(nums, target):
    lookup = {}
    for i, num in enumerate(nums):
        complement = target - num
        if complement in lookup:
            return (lookup[complement], i)
        lookup[num] = i
    return None

if __name__ == "__main__":
    nums = [2, 7, 11, 15]
    target = 9
    print("Two Sum result:", two_sum(nums, target))
