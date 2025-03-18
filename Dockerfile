FROM elixir:otp-27-alpine AS builder

WORKDIR /app

COPY mix.exs .
COPY mix.lock .
COPY .formatter.exs .

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get

COPY lib/ ./lib/
COPY config/ ./config/

ENV MIX_ENV=prod
RUN mix release

FROM elixir:otp-27-alpine

WORKDIR /app

COPY --from=builder /app/_build/prod/rel/prod/ ./_build/prod/rel/prod/

ENV MIX_ENV=prod
CMD ["_build/prod/rel/prod/bin/prod", "start"]
