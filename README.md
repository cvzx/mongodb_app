# Reservation CRUD App
This is a simple CRUD Rails app for managing reservations using MongoDB as the database.

## Prerequisites
Before you begin, make sure you have the following tools installed on your machine:
- Docker (version 20.10 or later)
- Docker Compose (version 1.29 or later)
## Installation
To install the app, clone the repository and run the following command in your terminal:

```ruby
$ docker-compose up
```
This command will start the MongoDB and Rails containers, and will run the Rails server on http://localhost:3000. You can access the web interface by opening this URL in your browser.

## Usage
The app provides a web interface for managing reservations. You can create, read, update, and delete reservations using the following routes:

- GET `/reservations/new` - displays a form for creating a new reservation
- POST `/reservations` - creates a new reservation
- GET `/reservations/:id` - displays a specific reservation
- GET `/reservations/:id/edit` - displays a form for editing a specific reservation
- PATCH `/reservations/:id` - updates a specific reservation
- DELETE `/reservations/:id` - deletes a specific reservation

Additionally, the app provides an API for managing reservations. You can access the API using the following routes:

- GET `/api/reservations` - lists all reservations in JSON format
- POST `/api/reservations` - creates a new reservation using JSON data
- GET `/api/reservations/:id` - displays a specific reservation in JSON format
- PATCH `/api/reservations/:id` - updates a specific reservation using JSON data
- DELETE `/api/reservations/:id` - deletes a specific reservation
