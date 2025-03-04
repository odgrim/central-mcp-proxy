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

## Docker Compose Structure

The project uses a modular Docker Compose structure:

- `docker-compose.yml`: Main file that includes Traefik configuration and references to service-specific files
- `docker-compose/github.yml`: GitHub MCP server configuration
- `docker-compose/notion.yml`: Notion MCP server configuration
- `docker-compose/memory-bank.yml`: Memory Bank MCP server configuration
- `docker-compose/linear.yml`: Linear MCP server configuration

This modular approach allows you to:
- Start all services: `docker compose up -d` (uses the default `all` profile set in `.env`)
- Start specific services using profiles: 
  - GitHub only: `docker compose --profile github up -d`
  - Notion only: `docker compose --profile notion up -d`
  - Memory Bank only: `docker compose --profile memory-bank up -d`
  - Linear only: `docker compose --profile linear up -d`
  - All services explicitly: `docker compose --profile all up -d`
- Add new services easily by creating a new file in the `docker-compose` directory

> **Note:** This project follows modern Docker Compose practices by omitting the `version` key, which is no longer required in Docker Compose V2 and above.

> **Note:** The network configuration is defined only in the main `docker-compose.yml` file to avoid conflicts. All services reference this network but don't redefine it.

> **Note:** The default profile is set to `all` in the `.env` file using the `COMPOSE_PROFILES` environment variable, allowing you to run `docker compose up` without explicitly specifying a profile.

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
