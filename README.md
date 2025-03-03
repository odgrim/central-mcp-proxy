# Central MCP Host

This project provides a centralized hosting environment for Model Context Protocol (MCP) servers using Docker, Traefik, and SuperGateway.

## Overview

This setup runs a Traefik reverse proxy to route requests to various MCP servers. SuperGateway is used to convert between stdio and SSE transports, allowing the MCP servers to communicate with clients using SSE.

## MCP Servers Included

- **Notion**: Interact with Notion databases and pages
- **Linear**: Interact with Linear Tickets
- **GitHub**: Interact with GitHub repositories, issues, and pull requests
- **Memory Bank**: Tools for recording project notes, thought trails and learnings

## Prerequisites

- Docker and Docker Compose
- Notion API token
- Linear API token
- GitHub API token

## Setup

1. Clone this repository
2. Copy the `.env.example` file to `.env` and fill in your API tokens:
   ```bash
   cp .env.example .env
   # Edit .env with your API tokens
   ```
3. Start the services:
   ```bash
   docker compose up -d
   ```

## Accessing the Services

Once running, you can access the services using each tool's respective path-based route

### Path-based Routing

- **Traefik Dashboard**: http://$HOSTNAME/dashboard/
- **Notion MCP Server**: 
  - SSE Endpoint: http://$HOSTNAME/notion/sse
  - Message Endpoint: http://$HOSTNAME/notion/message
- **GitHub MCP Server**: 
  - SSE Endpoint: http://$HOSTNAME/github/sse
  - Message Endpoint: http://$HOSTNAME/github/message
- **Linear MCP Server**: 
  - SSE Endpoint: http://$HOSTNAME/linear/sse
  - Message Endpoint: http://$HOSTNAME/linear/message
- **Memory-bank MCP Server**: 
  - SSE Endpoint: http://$HOSTNAME/memory-bank/sse
  - Message Endpoint: http://$HOSTNAME/memory-bank/message

## How It Works

### SuperGateway

SuperGateway is used to convert between stdio and SSE transports:

1. SuperGateway is installed in the container
2. It runs the MCP server command using the `--stdio` flag
3. It exposes HTTP endpoints for SSE connections and message sending

### Traefik Configuration

Traefik is configured to:

1. Route requests based on path prefix e.g. (`/notion`, `/github`, `/dashboard`)
2. Strip the path prefix before forwarding to the appropriate service
3. Set appropriate make sure connections don't die
4. Provide a dashboard for monitoring

## Testing the Setup

To test the setup, you can use the MCP Inspector:

```bash
npx @modelcontextprotocol/inspector node build/index.js
```

## Troubleshooting

- **Path routing issues**: Verify the path prefixes in traefik labels, SuperGateway baseUrl option and strip middleware configuration
- **MCP server errors**: Check the logs of the container:
  ```bash
  docker compose logs -f notion-gateway
  docker compose logs -f github-gateway
  ```
- **SuperGateway issues**: Ensure the MCP server command is correct and the package exists in node registry- some packages advertise under different names in mcp vs node registries.
