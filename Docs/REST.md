# Understanding REST and REST APIs

## Table of Contents

1. [What is REST?](#what-is-rest)
2. [What is a REST API?](#what-is-a-rest-api)
3. [REST Methods](#rest-methods)
   - [GET](#get)
   - [POST](#post)
   - [PUT](#put)
   - [DELETE](#delete)
   - [PATCH](#patch)
4. [Additional Properties of REST](#additional-properties-of-rest)
   - [Statelessness](#statelessness)
   - [Resource Representation](#resource-representation)
   - [Hypermedia as the Engine of Application State (HATEOAS)](#hypermedia-as-the-engine-of-application-state-hateoas)
   - [Caching](#caching)
   - [Layered System](#layered-system)
   - [Code on Demand (optional)](#code-on-demand-optional)

## What is REST?

**REST** stands for **Representational State Transfer**. It is an architectural style for designing networked applications. RESTful systems communicate over HTTP and use standard methods (like GET, POST, PUT, DELETE) to perform operations on resources.

### Key Principles of REST

1. **Statelessness**: Each request from a client to a server must contain all the information needed to understand and process the request. The server does not store any client context between requests.

2. **Client-Server Architecture**: The client and server are separate entities that interact with each other. This separation allows for the independent evolution of both the client and server.

3. **Uniform Interface**: REST APIs should have a uniform interface to simplify the architecture. This typically involves using standard HTTP methods and status codes.

4. **Resource-Based**: Resources are identified by URIs (Uniform Resource Identifiers). Each resource can be represented in multiple formats (e.g., JSON, XML).

5. **Stateless Communication**: Each interaction is independent; the server does not retain any information about the client's previous interactions.

## What is a REST API?

A **REST API** (Application Programming Interface) is an interface that adheres to the principles of REST. It allows different software systems to communicate over the web using HTTP requests.

### Key Components of a REST API

- **Resources**: The objects or data you want to expose (e.g., users, products). Each resource is identified by a unique URI.

- **HTTP Methods**:
  - **GET**: Retrieve data from the server.
  - **POST**: Send data to the server to create a new resource.
  - **PUT**: Update an existing resource.
  - **DELETE**: Remove a resource from the server.

- **Representations**: Resources can be represented in various formats, commonly JSON or XML. The client specifies the desired format in the request.

- **Status Codes**: REST APIs use standard HTTP status codes to indicate the outcome of requests. For example:
  - `200 OK`: The request was successful.
  - `201 Created`: A new resource was created.
  - `404 Not Found`: The requested resource does not exist.
  - `500 Internal Server Error`: A server error occurred.

### Example of a REST API

Consider a simple REST API for managing a collection of books. The API might have the following endpoints:

- **GET /books**: Retrieve a list of all books.
- **GET /books/{id}**: Retrieve details of a specific book by its ID.
- **POST /books**: Create a new book.
- **PUT /books/{id}**: Update an existing book.
- **DELETE /books/{id}**: Delete a book.

#### Example Request and Response

**Request**: Retrieve a specific book

```
GET /books/1 HTTP/1.1
Host: api.example.com
Accept: application/json
```

**Response** (JSON format):

```json
{
  "id": 1,
  "title": "The Great Gatsby",
  "author": "F. Scott Fitzgerald",
  "publishedYear": 1925
}
```

## REST Methods

REST APIs utilize standard HTTP methods to perform operations on resources. Each method corresponds to a specific action that can be taken with the resources. Here’s a detailed look at the primary HTTP methods used in REST:

### 1. GET

- **Purpose**: Retrieve data from the server.
- **Idempotent**: Yes (multiple identical requests will have the same effect as a single request).
- **Use Case**: Fetching a list of resources or a specific resource.

**Example**:
```http
GET /users
```
**Response**:
```json
[
  {"id": 1, "name": "Alice"},
  {"id": 2, "name": "Bob"}
]
```

### 2. POST

- **Purpose**: Send data to the server to create a new resource.
- **Idempotent**: No (multiple identical requests can create multiple resources).
- **Use Case**: Creating a new user or item.

**Example**:
```http
POST /users
Content-Type: application/json

{
  "name": "Charlie"
}
```
**Response**:
```http
HTTP/1.1 201 Created
Location: /users/3
```

### 3. PUT

- **Purpose**: Update an existing resource or create a new resource if it does not exist.
- **Idempotent**: Yes (updating a resource with the same data produces the same result).
- **Use Case**: Updating user details.

**Example**:
```http
PUT /users/1
Content-Type: application/json

{
  "name": "Alice Smith"
}
```
**Response**:
```http
HTTP/1.1 200 OK
```

### 4. DELETE

- **Purpose**: Remove a resource from the server.
- **Idempotent**: Yes (deleting the same resource multiple times has the same effect).
- **Use Case**: Deleting a user.

**Example**:
```http
DELETE /users/1
```
**Response**:
```http
HTTP/1.1 204 No Content
```

### 5. PATCH

- **Purpose**: Apply partial modifications to a resource.
- **Idempotent**: No (it can change the resource state with each request).
- **Use Case**: Updating specific fields of a resource without altering the entire resource.

**Example**:
```http
PATCH /users/1
Content-Type: application/json

{
  "name": "Alice Johnson"
}
```
**Response**:
```http
HTTP/1.1 200 OK
```

## Additional Properties of REST

### 1. Statelessness

Each HTTP request from a client contains all the information needed to process that request. The server does not store any session information about the client, which simplifies server design and allows for better scalability.

### 2. Resource Representation

Resources in REST are represented in various formats, commonly JSON or XML. The client can specify the desired format through the `Accept` header.

### 3. Hypermedia as the Engine of Application State (HATEOAS)

RESTful APIs can provide hyperlinks within responses that allow clients to discover actions they can perform on resources dynamically. This means that clients do not need to hard-code URLs; they can navigate the API based on the data received.

**Example**:
```json
{
  "id": 1,
  "name": "Alice",
  "links": [
    {"rel": "self", "href": "/users/1"},
    {"rel": "friends", "href": "/users/1/friends"}
  ]
}
```

### 4. Caching

REST APIs can leverage HTTP caching mechanisms to improve performance. Responses can include headers like `Cache-Control` to indicate how long responses can be cached, which reduces the need for repeated requests to the server.

### 5. Layered System

A client cannot ordinarily tell whether it is connected directly to the end server or an intermediary. This allows for load balancing, shared caches, and security measures without altering the API interface.

### 6. Code on Demand (optional)

Servers can extend client functionality by transferring executable code (e.g., JavaScript). This is an optional constraint and is rarely used in most RESTful APIs.
