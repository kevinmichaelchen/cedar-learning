Just me learning about Cedar.

## Getting Started

### Prerequisites

I'm using a few tools here:

- https://github.com/permitio/cedar-agent
  - A simple HTTP server.
  - Lets you manage data and policies via REST API.
  - Comes with nice [OpenAPI][swagger] docs and [Playground][rapidoc].
- https://github.com/cedar-policy/cedar/tree/main/cedar-policy-cli
  - Multiple use cases.
  - Evaluating requests.
  - Validating policies against a schema.
  - Linting/parsing policies.
  - Formatting policies.

[rapidoc]: http://localhost:8180/rapidoc
[swagger]: http://localhost:8180/swagger-ui

Both of these projects are available in the Tea package manager

```
tea --sync cedar-agent
tea --sync cedar
```

## Further Research

- Strong typing with [schemas][schemas]
- One-liner to stringify all policies into one JSON file

[schemas]: https://docs.cedarpolicy.com/schema.html

## Tasks

### start

Runs the Cedar Agent

```shell
cedar-agent
```

### store_policies

Store policies in Cedar Agent

```shell
curl -X PUT \
  -H "Content-Type: application/json" \
  -d @./examples/policies.json \
  http://localhost:8180/v1/policies
```

### store_data

Store data in Cedar Agent

```shell
curl -X PUT \
  -H "Content-Type: application/json" \
  -d @./examples/data.json \
  http://localhost:8180/v1/data
```

### run_check

Runs a sample authorization check

```shell
http POST http://localhost:8180/v1/is_authorized \
  principal="User::\"dumbledore@hogwarts.edu\"" \
  action="Action::\"delete\"" \
  resource="Document::\"cedar-agent.pdf\""
```

### merge_data

Merges all data into one JSON file.

```shell
jq -s '.[0]=([.[]]|flatten)|.[0]' examples/data/*.json > examples/data.json
```

### authorize

Sample authorization command

```shell
cedar authorize \
  --entities examples/data.json \
  --policies examples/policies/teacher-class-read.cedar \
  --principal "User::\"dumbledore@hogwarts.edu\"" \
  --action "Action::\"delete\"" \
  --resource "Document::\"cedar-agent.pdf\""
```
