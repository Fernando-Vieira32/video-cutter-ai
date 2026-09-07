# README

## Development with Docker

Requires Docker with the Compose plugin. Nothing else — no Ruby or Postgres on the host.

```sh
docker compose up
```

The app boots on http://localhost:3000. The entrypoint runs `bundle install` when the
Gemfile changed and `db:prepare` before starting Puma, so the first run also creates the
database.

Common commands:

```sh
docker compose exec web ./bin/rails console
docker compose exec web ./bin/rails db:migrate
docker compose exec web bundle exec rspec
docker compose exec web ./bin/rubocop
docker compose exec db psql -U video_cutter_ai video_cutter_ai_development

docker compose build          # after changing Dockerfile.dev
docker compose down           # stop
docker compose down -v        # stop and drop the database volume
```

Overridable env vars (put them in a `.env` file, which is gitignored):
`WEB_PORT` (default `3000`), `DB_USERNAME` / `DB_PASSWORD` (default `video_cutter_ai`),
and `UID` / `GID` (default `1000`) if your host user is not `1000:1000`.

The source tree is bind-mounted, so code changes are picked up without a rebuild. Gems
live in a named volume and survive `down`.

### Running without Docker

`config/database.yml` reads `DB_HOST`, `DB_PORT`, `DB_USERNAME` and `DB_PASSWORD`. With
those unset it falls back to the local Unix socket and the OS user, so `bin/rails server`
against a locally installed Postgres keeps working.

## Deployment

`Dockerfile` is the production image (Kamal), separate from `Dockerfile.dev`. See
`config/deploy.yml`.
