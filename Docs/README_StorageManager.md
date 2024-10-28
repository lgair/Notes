# Storage_Manager Class

## Overview

The `Storage_Manager` class provides a non-blocking interface for managing storage devices. It allows users to list connected devices, unmount devices, and connect to SMB/NFS storage without blocking the main thread. The class employs modern C++20 features such as `std::future` and `std::promise` for asynchronous operations, ensuring efficient resource management and responsiveness.

## Features

- **List Connected Devices**: Retrieve a list of all connected storage devices.
- **Non-blocking Unmounting**: Unmount devices asynchronously, with a notification when complete.
- **Non-blocking Connection**: Connect to SMB/NFS storage in the background, with a notification upon completion.
- **Cancellation of Ongoing Actions**: Cancel any ongoing unmount or connection process.
- **Thread Safety**: Safe for concurrent use with proper locking mechanisms.

## Methods

### 1. `static std::map<std::string, std::map<std::string, std::string>> listConnectedDevices()`

Lists all connected storage devices. Returns a map containing device names and their respective attributes.

### 2. `static std::string unmountDevice(const std::string &deviceName)`

Attempts to unmount the specified device. If the action takes longer than 1 second, it returns a message indicating that the action will continue in the background. 

**Returns**: A string message indicating the status of the unmounting action.

### 3. `static std::string connectToStorage(const std::string &ipPath, const std::string &username, const std::string &password)`

Connects to the specified SMB/NFS storage device asynchronously. Similar to unmounting, if the action is not completed within 1 second, it returns a message indicating ongoing background processing.

**Returns**: A string message indicating the status of the connection attempt.

### 4. `static void cancelOngoingAction()`

Cancels any ongoing unmount or connection processes. This method returns immediately, regardless of whether the underlying action is fully stopped.

### 5. `static void notifyCompletion()`

Notifies when the background action has completed.

## Usage Example

```cpp
#include "Storage_Manager.h"

int main() {
    // List connected devices
    auto devices = Storage_Manager::listConnectedDevices();
    
    // Unmount a device
    std::string unmountStatus = Storage_Manager::unmountDevice("example_device");
    std::cout << unmountStatus << std::endl;

    // Connect to a storage device
    std::string connectStatus = Storage_Manager::connectToStorage("192.168.1.1/share", "user", "pass");
    std::cout << connectStatus << std::endl;

    // Cancel any ongoing actions
    Storage_Manager::cancelOngoingAction();

    return 0;
}
```

## Thread Safety

This class is designed to be thread-safe. It uses mutexes and atomic flags to ensure that methods can be called concurrently without causing data races or inconsistencies.

## Requirements

- C++20 compatible compiler
- Standard libraries: `<map>`, `<string>`, `<future>`, `<atomic>`, `<condition_variable>`, `<mutex>`, `<thread>`, `<chrono>`, `<iostream>`, and `<filesystem>`
