# Implementation Plan for Storage Management Class in C++

## Overview

The `StorageManager` class will manage storage device functionalities, utilizing the Observer design pattern to handle notifications about the completion of asynchronous operations and state changes.

## Why Use the Observer Pattern

The Observer Pattern is chosen for the following reasons:

- **Decoupling**: It allows the `StorageManager` to notify multiple clients about events without tightly coupling them to the class itself. Clients can subscribe or unsubscribe from notifications as needed.
  
- **Asynchronous Handling**: Many operations in storage management (like file transfers, device connections, etc.) are asynchronous. The Observer Pattern facilitates notifying clients when these operations complete or when their status changes.

- **Scalability**: New clients can be added without modifying the `StorageManager`, promoting an extensible architecture where different parts of the system can evolve independently.

## Class Overview

### Class Name: `StorageManager`

### Responsibilities

- Manage storage devices (list, connect, unmount, format).
- Handle file and directory operations (list, delete, transfer).
- Notify clients of state changes and completion of operations.

## Design Patterns

### Observer Pattern

#### Interface for Observer

```cpp
class IObserver {
public:
    virtual void onNotify(const std::string& message) = 0;
    virtual ~IObserver() = default;
};
```

#### Interface for Subject

```cpp
class ISubject {
public:
    virtual void attach(IObserver* observer) = 0;
    virtual void detach(IObserver* observer) = 0;
    virtual void notifyObservers(const std::string& message) = 0;
    virtual ~ISubject() = default;
};
```

### `StorageManager` Class Interface

#### 1. Iteration 1

```cpp
class StorageManager : public ISubject {
public:
    // Lists all connected storage devices
    virtual std::unordered_map<std::string, std::tuple<std::string, std::string, std::string>> listConnectedDevices() = 0;

    // Unmounts a specified storage device
    virtual bool unmountDevice(const std::string& deviceName) = 0;

    // Connects to an SMB/NFS storage device
    virtual bool connectToStorage(const std::string& ipPath, const std::string& username, const std::string& password) = 0;

    // Observer methods
    void attach(IObserver* observer) override;
    void detach(IObserver* observer) override;
    void notifyObservers(const std::string& message) override;
};
```

#### 2. Iteration 2

```cpp
class StorageManager : public ISubject {
public:
    // Non-blocking unmount device
    virtual std::string unmountDeviceAsync(const std::string& deviceName) = 0;

    // Non-blocking connect to storage
    virtual std::string connectToStorageAsync(const std::string& ipPath, const std::string& username, const std::string& password) = 0;

    // Cancels an ongoing background action
    virtual void cancelBackgroundAction() = 0;
};
```

#### 3. Iteration 3

```cpp
class StorageManager : public ISubject {
public:
    // Non-blocking method to list files/directories
    virtual std::vector<std::vector<std::string>> listFilesAsync(const std::string& path, size_t offset = 0) = 0;

    // Notify event to signal completion
    void onNotify() override;
};
```

#### 4. Iteration 4

```cpp
class StorageManager : public ISubject {
public:
    // Deletes a specified file/directory
    virtual bool deletePath(const std::string& path) = 0;

    // Formats a storage device
    virtual bool formatDevice(const std::string& devicePath, const std::string& fsType = "") = 0;
};
```

#### 5. Iteration 5

```cpp
class StorageManager : public ISubject {
public:
    // Transfers files between storage devices or paths
    virtual void transferFile(const std::string& sourcePath, const std::string& destinationPath, bool move) = 0;

    // Emit progress events during transfer
    void onProgressUpdate(size_t progress);
};
```

## Additional Considerations

- **Character Encoding**: Use `std::wstring` or `std::string` to handle a wide character set.
- **Error Handling**: Implement robust error handling using exceptions or return codes.
- **Thread Safety**: Ensure thread safety for methods that modify shared state, using mutexes or other synchronization mechanisms.
