# rute

Map local domains to ports over HTTPS. One domain, one command.

`rute` is a thin orchestrator over tools you already have:

- **nginx** — the `:80`/`:443` server (vhosts, proxy, websocket/HMR)
- **mkcert** — a trusted cert for exactly the domains you add
- **/etc/hosts** — point each domain at `127.0.0.1`

No wildcards. Every domain is explicit. `rute` writes config from a flat state
file and reloads.

## Install

```bash
brew tap haiigas/homebrew-rute
brew install rute
```

Requires `nginx` and `mkcert` (pulled in automatically).

## Usage

```bash
rute add example.local        4002
rute add api.example.local    8080
rute add pay.example.local    4003
rute add example.test         4006
rute add studio.example.test  8001
rute ls
rute rm pay.example.local
rute sync
rute doctor
```

Every `add`/`rm` regenerates nginx + hosts + the cert and reloads, so the
route is live immediately. First run asks `sudo` for `/etc/hosts` and to start
nginx; later changes only need an nginx reload.

## Behind the scenes

```
~/.config/rute/routes             # "domain port" per line (the state)
$NGINX/servers/rute.conf          # generated: map + server block
$NGINX/certs/rute.pem             # generated: cert, SAN = every domain
/etc/hosts                        # generated block -> 127.0.0.1
```

Point your frontends/backends at their own ports (`vite --port 4002`,
`go run` on `:8080`, `artisan serve --port=4006`); `rute` only routes.

## Caveats

- `:443` needs root. `rute` uses `sudo` for hosts + nginx only.
- One cert holds all domains as SANs; it is reissued whenever the set changes.
- This owns nginx globally. Don't run another `:443` server (valet, mkdev)
  alongside it.

## Uninstall

```bash
brew uninstall rute           # remove the CLI
brew uninstall --zap rute     # also remove everything it generated
```

`--zap` clears the generated nginx vhost + cert, `~/.config/rute`, the
`# >>> rute >>>` block in `/etc/hosts`, then reloads nginx. Stop nginx too if
you don't want it running:

```bash
brew services stop nginx
```

## License

MIT
