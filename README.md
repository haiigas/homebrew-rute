# rute

Map local domains to ports over HTTPS — and run your project dev servers.

`rute` is a thin orchestrator over tools you already have:

- **nginx** — the `:80`/`:443` server (vhosts, proxy, websocket/HMR)
- **mkcert** — a trusted cert for exactly the domains you add
- **/etc/hosts** — point each domain at `127.0.0.1` and `::1`

Two modes:

- **proxy** — map a domain to a port that is already running.
- **link** — read a `.rute` file in your project, start the dev servers, and
  map every domain. One command.

## Install

```
brew tap haiigas/homebrew-rute
brew install rute
```

Requires `nginx` and `mkcert` (pulled in automatically).

## Proxy mode

```
rute proxy email.example.dev 8025
rute ls
rute rm email.example.dev
```

## Project mode

Put a `.rute` file in the project root:

```
name  = site
group = myapp

[site]
command = pnpm dev -- --port 4002
port    = 4002
domain  = example.dev, api.example.dev
```

Then, from the project directory:

```
rute link               # link project and start dev server
rute ls                 # view grouped projects and proxies
rute restart            # restart current project
rute down [group/name]  # stop project
rute up [group/name]    # start project
rute unlink             # unlink and stop project
```

## Commands

| command | what |
|---|---|
| `rute proxy <domain> <port>` | proxy a domain to a running port |
| `rute link [dir]` | read `.rute`, start servers, map domains |
| `rute unlink [target]` | stop + remove a project's routes |
| `rute up [target]` / `rute down [target]` | start / stop a project |
| `rute restart [target]` | stop then start a project |
| `rute ls` | list grouped projects and standalone proxies |
| `rute rm <domain>` | remove one route |
| `rute sync` | regenerate nginx/hosts/cert and reload |
| `rute doctor` | check deps and services |

## License

MIT
