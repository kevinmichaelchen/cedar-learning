Just me learning about [Cedar][cedar].

[cedar]: https://docs.cedarpolicy.com/

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

Both of these projects are available in the [Tea][tea] package manager

```
tea --sync cedar-agent
tea --sync cedar
```

[tea]: https://docs.tea.xyz/getting-started/install-tea

### Authorization Checks

#### Albus Dumbledore

##### Hogwarts Classrooms

Can Albus Dumbledore view the Astronomy classroom at Hogwarts?

```shell
cedar authorize \
  --schema examples/schema.json \
  --policies examples/policies/viewClassroom.cedar \
  --entities examples/entities.json \
  --principal Platform::Teacher::\"dumbledore@hogwarts.edu\" \
  --action Platform::Action::\"viewClassroom\" \
  --resource Platform::Classroom::\"astronomy\"
```

As you'd expect, because Dumbledore teaches at Hogwarts, the reponse is:

```
ALLOW
```

##### Beauxbatons Classrooms

Can Albus Dumbledore view the Potions classroom at Beauxbatons?

```shell
cedar authorize \
  --schema examples/schema.json \
  --policies examples/policies/viewClassroom.cedar \
  --entities examples/entities.json \
  --principal Platform::Teacher::\"dumbledore@hogwarts.edu\" \
  --action Platform::Action::\"viewClassroom\" \
  --resource Platform::Classroom::\"potions\"
```

As you'd expect, because Dumbledore teaches at Hogwarts and not Beauxbatons,
the reponse is:

```
DENY
```

## Further Research

- Policy [Templates][templates]
  - We can't write a distinct policy for every principal/resource combination. That would be crazy.
- Strong typing with [schemas][schemas]
- One-liner to stringify all policies into one JSON file
- Calling this from Golang services?

[templates]: https://docs.cedarpolicy.com/templates.html
[schemas]: https://docs.cedarpolicy.com/schema.html

## Tasks

### merge_data

Merges all entities data into one entities.json file.

```shell
jq -s '.[0]=([.[]]|flatten)|.[0]' examples/entities/*.json > examples/entities.json
```

### check_parse

Check that policy successfully parses.

```shell
cedar check-parse \
  --policies examples/policies/viewClassroom.cedar
```

### validate

Validates the policy against the schema.

```shell
cedar validate \
  --schema examples/schema.json \
  --policies examples/policies/viewClassroom.cedar
```
