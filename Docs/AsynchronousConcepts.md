# C++ Futures, Promises, Multithreading, Mutexes, and Locks

## Table of Contents
1. [Introduction to Multithreading](#introduction-to-multithreading)
2. [Mutexes and Locks](#mutexes-and-locks)
3. [Futures and Promises](#futures-and-promises)
   - [How They Work Together](#how-they-work-together)
   - [Advanced Concepts](#advanced-concepts)
4. [Comparison of Concepts](#comparison-of-concepts)

---

## Introduction to Multithreading

### Definition
Multithreading is the capability of a CPU, or a single core in a multi-core processor, to provide multiple threads of execution concurrently. This enables the execution of multiple tasks simultaneously.

### Use Cases
- **Performance Optimization**: Allows for tasks to run in parallel, utilizing multi-core processors.
- **I/O Bound Tasks**: Useful for performing background operations without blocking the main thread, such as file reading or network requests.

### Complexity
Managing multiple threads introduces challenges such as:
- **Race Conditions**: Occur when multiple threads access shared data concurrently, leading to inconsistent data states.
- **Deadlocks**: Situations where two or more threads are blocked forever, waiting for each other to release resources.

---

## Mutexes and Locks

### Definition
A **mutex** (short for mutual exclusion) is a synchronization primitive that prevents multiple threads from accessing shared resources simultaneously. Locks are mechanisms that control access to these resources.

### Types of Locks
- **Mutex**: A simple lock that protects shared data.
- **Recursive Mutex**: Allows the same thread to acquire the lock multiple times.
- **Shared Mutex**: Allows multiple threads to read shared data but only one thread to write.

### Use Cases
- **Protecting Shared Resources**: Essential when multiple threads need to read from or write to shared variables or data structures.

### Complexity
Using mutexes and locks can lead to:
- **Increased Complexity**: Requires careful design to avoid deadlocks.
- **Performance Overhead**: Locking can introduce delays, especially if threads frequently require access to the same resource.

---

## Futures and Promises

### Definition
- **Promise**: An object that allows you to set a value or an exception to be retrieved later. It acts as a producer of the result.
- **Future**: An object that acts as a placeholder for a value that is expected to be available in the future. It acts as a consumer of the result.

### How They Work Together
1. **Creation**: You create a `std::promise` object, which is associated with a `std::future` obtained via `promise.get_future()`.
2. **Setting Value**: The promise is fulfilled by calling `promise.set_value(value)` or `promise.set_exception(exception)`.
3. **Retrieving Value**: The future can be used to retrieve the value using `future.get()`, which blocks until the value is ready.

#### Example Usage
```cpp
#include <iostream>
#include <future>
#include <thread>
#include <chrono>

int computeValue(int x) {
    if (x < 0) {
        throw std::invalid_argument("Negative value not allowed");
    }
    std::this_thread::sleep_for(std::chrono::seconds(1)); // Simulate computation
    return x * 2;
}

void asyncCompute(std::promise<int>& promiseObj, int value) {
    try {
        int result = computeValue(value);
        promiseObj.set_value(result);
    } catch (...) {
        promiseObj.set_exception(std::current_exception());
    }
}

int main() {
    std::promise<int> promiseObj;
    std::future<int> futureObj = promiseObj.get_future();

    std::thread t(asyncCompute, std::ref(promiseObj), 10); // Valid input

    try {
        int result = futureObj.get(); // This will block until the value is ready
        std::cout << "Computed result: " << result << std::endl;
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
    }

    t.join(); // Ensure thread completes
    return 0;
}
```

### Advanced Concepts
1. **Shared State**: When a promise is fulfilled, it shares its state with the corresponding future, allowing the future to access the result or exception.
2. **Multiple Futures from One Promise**: You can create a shared promise using `std::shared_future`, allowing multiple futures to access the same result.
3. **Combining with `std::async`**: Simplifies the process by managing threads automatically.
```cpp
#include <iostream>
#include <future>

int computeValue(int x) {
    return x * 2;
}

int main() {
    std::future<int> futureObj = std::async(std::launch::async, computeValue, 10);

    int result = futureObj.get(); // Get the result, blocks if not ready
    std::cout << "Computed result: " << result << std::endl;

    return 0;
}
```

---

## Comparison of Concepts

| Feature               | Multithreading                     | Mutexes/Locks                  | Futures/Promises                |
|-----------------------|------------------------------------|--------------------------------|---------------------------------|
| **Abstraction Level** | Low (manual thread management)     | Low (manual synchronization)   | High (automatic handling)       |
| **Ease of Use**       | Complex, error-prone               | Complex, requires careful design| Easier, less boilerplate        |
| **Synchronization**    | Manual using mutexes/locks         | Explicit control                | Implicit via futures            |
| **Use Cases**         | Performance optimization            | Protecting shared resources    | Asynchronous task management    |
| **Error Handling**    | Requires careful handling           | Can lead to deadlocks          | Exceptions can be propagated     |

---
