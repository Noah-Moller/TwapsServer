# TwapsServer

A simple server for hosting and distributing Twaps (The Web for Apps).

## Overview

TwapsServer is part of the Twaps ecosystem, which brings web-like dynamics to native macOS applications. This server component is responsible for:

- Hosting Twaps (dynamic native UI modules)
- Serving Twaps to client applications
- Managing Twap metadata and versioning

## 🧪 Experimental Project

**Note:** This is an experimental project created to explore the concept of dynamic native UI modules. It is not intended for production use at this stage. The code is shared to inspire discussion and collaboration around the idea of bringing web-like dynamics to native app development.

## Features

- Simple HTTP API for pushing and retrieving Twaps
- Local file storage for Twaps
- Support for URL-based Twap addressing

## Getting Started

### Prerequisites

- macOS 13.0+ (Ventura or later)
- Swift 6.0+
- Xcode 15.0+

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Noah-Moller/TwapsServer.git
   cd TwapsServer
   ```

2. Build the server:
   ```bash
   swift build
   ```

3. Run the server:
   ```bash
   swift run
   ```

The server will start on `http://localhost:8080`.

## API Endpoints

### GET /

Returns a simple message to confirm the server is running.

### POST /twap

Retrieves a Twap by URL.

**Request Body:** The URL of the Twap to retrieve (plain text)

**Response:** The Swift source code of the Twap

### POST /api/twaps

Pushes a Twap to the server.

**Request Body:** JSON object with the following properties:
- `source`: The Swift source code of the Twap (with escaped newlines)
- `url`: The URL where the Twap will be accessible
- `id`: A unique identifier for the Twap

**Response:** JSON object with a success message and the URL of the Twap

## Related Projects

- [TwapsCLI](https://github.com/Noah-Moller/TwapsCLI): A command-line tool for building and publishing Twaps
- [TwapsClient](https://github.com/Noah-Moller/TwapsClient): A macOS app for loading and displaying Twaps

## License

This project is licensed under the MIT License - see the LICENSE file for details.
