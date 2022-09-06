FROM elixir:1.12.2-alpine AS build

ARG CI
ARG GH_PERSONNAL_TOKEN

# prepare build dir
WORKDIR /app


# install build dependencies
RUN apk add --no-cache build-base git python3 openssh

# install hex + rebar
RUN mix archive.install github hexpm/hex branch latest --force && \
    mix local.rebar --force

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
RUN mix release dev_tools

# prepare release image
FROM erlang:24-alpine

RUN adduser -D lenra
ENV SHELL=sh

USER lenra

WORKDIR /lenra/devtools
COPY --from=build --chown=lenra /app/_build/prod/rel/dev_tools .

ENTRYPOINT [ "/lenra/devtools/bin/dev_tools" ]
CMD ["start"]