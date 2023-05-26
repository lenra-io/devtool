FROM elixir:1.13-alpine AS build

ARG CI
ARG GH_PERSONNAL_TOKEN

# prepare build dir
WORKDIR /app


# install build dependencies
RUN apk add --no-cache build-base git python3 openssh

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix archive.install github hexpm/hex branch latest --force 


# set build ENV
ENV MIX_ENV=prod

# copy needed files
COPY ./server .
COPY ./client/build/web/ ./priv/static/

ENV SECRET_KEY_BASE=Lhk7igVi9p3jnV9gMqi7+pSFFfo7R3V9PnXXt1FnvyHSqjYFThwDecnS1TmR2hUE

# install mix dependencies
RUN mix deps.get
RUN mix phx.digest

# compile and build release
RUN mix compile
RUN mix distillery.release

# prepare release image
FROM erlang:24-alpine

RUN adduser -D lenra
RUN apk update && apk --no-cache --update add bash

ENV SHELL=sh

RUN mkdir -p /lenra/devtools/rel/dev_tools/tmp && \
    chmod -R ugo+rw /lenra/devtools/rel/dev_tools/tmp

USER lenra

WORKDIR /lenra/devtools
COPY --chown=lenra --chmod=777 entrypoint.sh /entrypoint.sh
COPY --from=build --chown=lenra /app/_build/prod/ .
RUN ls /
RUN ls /lenra/devtools


WORKDIR /lenra/devtools/rel/dev_tools

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["foreground"]