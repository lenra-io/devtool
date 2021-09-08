FROM elixir:1.12-alpine AS build

ARG CI
ARG GH_PERSONNAL_TOKEN

# prepare build dir
WORKDIR /app

# install build dependencies
RUN apk add --no-cache build-base git python3 openssh

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# copy needed files
COPY ./server .
COPY ./client/build/web/ ./priv/static/

ENV SECRET_KEY_BASE=Lhk7igVi9p3jnV9gMqi7+pSFFfo7R3V9PnXXt1FnvyHSqjYFThwDecnS1TmR2hUE

RUN mix phx.digest

# install mix dependencies
RUN mix do deps.get, deps.compile

# compile and build release
RUN mix do compile, release dev_tools

# prepare release image
FROM alpine:latest

WORKDIR /lenra/devtools
COPY --from=build /app/_build/prod/ .
COPY ./entrypoint.sh .

# Install elixir dependencies
RUN apk add --no-cache ncurses-libs libstdc++

USER root
RUN mkdir -p /lenra/devtools/rel/dev_tools/tmp && \ 
    chmod -R ugo+rw /lenra/devtools/rel/dev_tools/tmp

ENTRYPOINT [ "/lenra/devtools/entrypoint.sh" ]