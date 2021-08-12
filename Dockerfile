FROM elixir:1.11-alpine AS build

ARG CI
ARG GITHUB_PERSONNAL_TOKEN

# prepare build dir
WORKDIR /app

# install build dependencies
RUN apk add --no-cache build-base git python3 openssh

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=dev

# copy needed files
COPY . .

# install mix dependencies
RUN mix do deps.get, deps.compile

# compile and build release
RUN mix do compile, release dev_tools

# prepare release image
FROM erlang:22-alpine

WORKDIR /app
COPY --from=build /app/_build/dev/rel/dev_tools .

RUN adduser -D lenra && chown -R lenra:lenra .
USER lenra

ENTRYPOINT [ "bin/dev_tools" ]
CMD ["start"]