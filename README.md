# rute

Map local domains to ports over HTTPS — and run your project dev servers.

`rute` is a thin orchestrator over tools you already have:

- **nginx** — the `:80`/`:443` server (vhosts, proxy, websocket/HMR)
- **mkcert** — a trusted cert for exactly the domains you add
- **/etc/hosts** — point each domain at `127.0.0.1`

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
rute proxy api.example.dev 8080
rute ls
rute rm api.example.dev
```

Point the domain at a port you run yourself.

## Project mode

Put a `.rute` file in the project root:

```
name = myapp

[site]
command = pnpm dev -- --port 4002
port    = 4002
domain  = example.dev, www.example.dev
```

Then, from the project:

```
rute link        # start every [site], wait for its port, map its domains
rute ls
rute down        # stop the project's servers
rute up          # start them again
rute restart     # reload .rute changes (port/domains/cmd), restart servers, update routes
rute unlink      # stop + remove the routes
```

Domains go on one line, comma-separated. `[site]` can repeat — one block per
server/port. Every domain on a site shares that port and one process.
If you change `port`, `domain`, or `command` in `.rute`, just run `rute restart`
to apply the changes and update nginx automatically.

### Multiple servers (one repo)

```
name = myapp

[site]
command = pnpm dev:web -- --port 4002
port    = 4002
domain  = example.dev

[site]
command = pnpm dev:pay -- --port 4003
port    = 4003
domain  = pay.example.dev

[site]
command = go run ./cmd/api
port    = 8080
domain  = api.example.dev
```

`rute link` starts all three, waits for each port, and maps each domain.

## How it works

```
~/.config/rute/routes                  # domain -> port (proxy + linked routes)
~/.config/rute/projects/<name>/        # pid + log per [site]
$NGINX/servers/rute.conf               # generated: map + server block
$NGINX/certs/rute.pem                  # generated: cert, SAN = every domain
/etc/hosts                             # generated block -> 127.0.0.1
```

`rute link` starts each `command` in its own process group (log at
`~/.config/rute/projects/<name>/site-<n>.log`), waits until `port` accepts
connections, then registers the routes and reloads nginx. `rute down` kills the
whole group, so child processes (vite, go, etc.) go too.

## Commands

| command | what |
|---|---|
| `rute proxy <domain> <port>` | proxy a domain to a running port |
| `rute link [dir]` | read `.rute`, start servers, map domains |
| `rute unlink [dir]` | stop + remove a project's routes |
| `rute up <name>` / `rute down <name>` | start / stop a project |
| `rute restart <name>` | stop then start a project |
| `rute ls` | list routes and projects |
| `rute rm <domain>` | remove one route |
| `rute sync` | regenerate nginx/hosts/cert and reload |
| `rute doctor` | check deps and services |

## Caveats

- Pin the port in `.rute` — dev servers must not pick a random one.
- `:443` needs root. `rute` uses `sudo` for `/etc/hosts` and nginx only.
- One cert holds all domains as SANs; it is reissued whenever the set changes.
- This owns nginx globally. Don't run another `:443` server alongside it.

## Uninstall

```
brew uninstall rute           # remove the CLI
brew uninstall --zap rute     # also remove everything it generated
```

## License

MIT
