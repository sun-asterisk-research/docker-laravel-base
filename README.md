# Laravel base image

A base image for Laravel applications. Built upon the official PHP image, bootstrap by s6-overlay & serve with NGINX.

## Quick start

Create a Dockerfile in your application directory.

```Dockerfile
FROM ghcr.io/sun-asterisk-research/laravel-base:8.1-alpine3.16

COPY . .
```

Build and run.

```sh
docker build . -t my-application
docker run --rm -i my-application
```

## Running modes

By default, the container starts in `full` mode, which includes

- NGINX & PHP-FPM for serving your application
- Laravel queue worker (invoked using `php artisan queue:work`)
- Crontab for Laravel schedule

For horizontal scaling, most likely you'd like to split these responsibilities to different containers.
The crontab container for example shouldn't be scaled up to avoid duplication of scheduled jobs.
You can customize which role you'd want your container to have using the `MODE` environment variable.
Possible values are

- `full`: full mode, includes all processes
- `server`: NGINX & PHP-FPM
- `worker`: queue worker
- `cron`: crontab

You can also combine multiple roles for a container, for example `MODE=server+worker`.

## What the bootstrap script does

- Setup database
  - Ensure database file exist for `sqlite` driver
  - Ensure database server is reachable
  - Run database migration
- Run optimize command
- Link storage directories
- Make required directories writable by the web server

## Environment variables

Container behavior can be customized using environment variables.

| Variable                  | Description                                                      | Default    |
|---------------------------|------------------------------------------------------------------|------------|
| `APPLICATION_ROOT`        | The application root directory                                   | `/srv/app` |
| `LARAVEL_OPTIMIZE`        | Run the `optimize` command                                       | `true`     |
| `LARAVEL_SKIP_DATABASE`   | Skip database setup entirely                                     | `false`    |
| `LARAVEL_RUN_MIGRATION`   | Run the `db:migrate` command                                     | `true`     |
| `LARAVEL_LINK_STORAGE`    | Run the `storage:link` command                                   | `true`     |
| `LARAVEL_FIX_PERMISSIONS` | Try to fix write permissions for directories required by Laravel | `true`     |
| `LARAVEL_WORKER_COMMAND`  | Queue worker command to run (`work` or `listen`)                 | `work`     |
| `NGINX_CONF_SNIPPET`      | Extra configuration snippet for NGINX                            |            |

### Customizing queue worker command

Queue worker command can be set using the `LARAVEL_WORKER_COMMAND` variable (`work` or `listen`).
Default value is `work`.

Queue worker flags can be set using environment variables prefixed with `LARAVEL_WORKER_`.
For example the following environment variables

```sh
LARAVEL_WORKER_COMMAND=work
LARAVEL_WORKER_SLEEP=1
LARAVEL_WORKER_MAX_JOBS=1000
```

Would create this command

```sh
php artisan queue:work --sleep=1 --max-jobs=1000
```

### Configuring PHP

PHP & PHP-FPM config values can be set using variables prefixed with `PHP.` and `PHP_FPM.`
The following values are changed by default.

```sh
PHP_FPM.pm=ondemand
PHP_FPM.pm.max_children=40
PHP_FPM.pm.process_idle_timeout=300s
```

### Configuring s6-overlay

See [s6-overlay docs](https://github.com/just-containers/s6-overlay#customizing-s6-behaviour) for possible options to
customize s6-overlay behavior. The following values are changed by default.

```sh
S6_CMD_WAIT_FOR_SERVICES_MAXTIME=100000
S6_BEHAVIOUR_IF_STAGE2_FAILS=2
```

## Customize container logs

s6-overlay logs can be configured using `S6_LOGGING` variable. Set to `0` to disable logging.

You should set `LOG_CHANNEL=stderr` (Laravel 5.6+) so your application logs can be captured by central logging stacks.

If your application is behind a reverse proxy, may be you don't care about NGINX access logs.
In that case, you can disable access logs by setting `NGINX_CONF_SNIPPET=access_log off;`.
