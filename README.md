<p align="center">
  <img width="600" src="https://github.com/kevinmichaelchen/cedar-learning/assets/5129994/6c5b1219-4fb1-4f21-a9a7-01baf4788341" />
</p>

Just me learning about [Cedar][cedar].

Why?

- It seems [more fitting][permit-opa-cedar] for application-level authorization than something like Open Policy / Rego.
- It has [AWS' backing][aws-cedar-press] and has been rigorously tested.
- It's compatible with [AWS Verified Permissions][aws-vp], a managed fine-grained authorization service.
  - There's even a [Terraform module][aws-vp-tf] for that coming soon!

[aws-vp-tf]: https://github.com/hashicorp/terraform-provider-aws/issues/32158
[aws-vp]: https://aws.amazon.com/verified-permissions/
[aws-cedar-press]: https://aws.amazon.com/about-aws/whats-new/2023/05/cedar-open-source-language-access-control/
[cedar]: https://docs.cedarpolicy.com/
[permit-opa-cedar]: https://www.permit.io/blog/opa-vs-cedar

## Prerequisites

I'm using one tool here:

- The [`cedar` CLI][cedar-cli]
  - Supports linting, checking, formatting, validating, etc.
  - Available in the [Tea][tea] package manager: `tea --sync cedar`

[tea]: https://docs.tea.xyz/getting-started/install-tea
[cedar-cli]: https://github.com/cedar-policy/cedar/tree/main/cedar-policy-cli

## Getting Started

We can perform authorization checks with the Cedar CLI by pointing it at our data and policies, and letting it evaluate an authorization decision for a given principal (user), action (read), and resource (classroom).

### Are you familiar with the world of Harry Potter?

We illustrate how authorization works by borrowing examples from Harry Potter.

Check out the [**docs**](./docs/README.md) folder for details.

![students](./docs/4-students.svg)

### Where are the policies defined?

See [**policies.cedar**](./examples/policies.cedar).

### Where is the data defined?

If you want to torture yourself by looking at JSON, see the [**entities**](./examples/entities) directory, or [**entities.json**](./examples/entities.json) (which is just the concatenation of all those files).

In production, we could use an event-driven architecture with [OPAL][opal] to sync data changes from a database into Cedar Agent.

Examples of data changes include:

- a teacher joins/leaves a school
- a teacher is assigned/unassigned a classroom
- a classroom gets created/destroyed
- a student enrolls/un-enrolls from a classroom

[opal]: https://www.opal.ac/

### Who can view Hogwarts classrooms?

The answer is as you'd expect:

- Teachers or administrators of _Hogwarts School of Witchcraft and Wizardry_ can view classrooms at Hogwarts.
- Employees (teachers or admins) of any Hogwarts parent org units (e.g., the Ministry of Magic) can view Hogwarts classrooms.
- Employees of other schools cannot view Hogwarts classrooms.

```shell
for i in \
  Platform::Admin::\"dumbledore@hogwarts.edu\" \
  Platform::Teacher::\"snape@hogwarts.edu\" \
  Platform::Teacher::\"aurora.sinistra@hogwarts.edu\" \
  Platform::Admin::\"maxime@beauxbatons.edu\" \
  Platform::Teacher::\"molina@beauxbatons.edu\" \
  Platform::Admin::\"barty.crouch@ministry.edu\" \
  Platform::Teacher::\"arthur.weasley@ministry.edu\" \
  Platform::Admin::\"president@magical_congress_usa.edu\" \
  Platform::Teacher::\"teacher@magical_congress_usa.edu\" \
; do \
  echo "\n\n~~~" ; \
  echo $i ; \
  cedar authorize \
    --schema examples/schema.json \
    --policies examples/policies.cedar \
    --entities examples/entities.json \
    --principal $i \
    --action Platform::Action::\"viewClassroom\" \
    --resource Platform::Classroom::\"hogwarts_astronomy\" ; \
done
```

The output looks like the following:

| User           | Result         | Reason                                                         |
|----------------|----------------|----------------------------------------------------------------|
| dumbledore     | **ALLOW** :mage:   | He administrates Hogwarts                                      |
| snape          | DENY :no_good: | Does not teach Astronomy                                       |
| sinistra       | **ALLOW** :mage:   | She teaches Astronomy :crystal_ball: at Hogwarts               |
| maxime         | DENY :no_good: | Admin at a completely different school                         |
| molina         | DENY :no_good: | Teaches at a completely different school                       |
| barty.crouch   | **ALLOW** :mage:   | Administrates a higher level org unit that oversees Hogwarts   |
| arthur.weasley | DENY :no_good: | Teaches at the Ministry, but is not an admin                   |
| president      | DENY :no_good: | Admin at a higher-level org unit, but one that isn't reachable |


## Further Research

- Policy [Templates][templates]
  - We can't write a distinct policy for every principal/resource combination. That would be crazy
- One-liner to stringify all policies into one JSON file
- Calling this from Golang services?
  - See the [Go SDK][go-sdk] for AWS Verified Permissions
  - Also see Cedar Agent's REST API

[go-sdk]: https://github.com/aws/aws-sdk-go-v2/blob/v1.21.0/service/verifiedpermissions/api_op_IsAuthorized.go
[templates]: https://docs.cedarpolicy.com/templates.html
[schemas]: https://docs.cedarpolicy.com/schema.html

## Tasks

### merge

Merges all entities and policies into `entities.json` and `policies.cedar`, respectively.

```shell
jq -s '.[0]=([.[]]|flatten)|.[0]' examples/entities/*.json > examples/entities.json
cat examples/policies/* > examples/policies.cedar
```

### check_parse

Check that policy successfully parses.

```shell
cedar check-parse \
  --policies examples/policies.cedar
```

### validate

Validates the policy against the schema.

```shell
cedar validate \
  --schema examples/schema.json \
  --policies examples/policies.cedar
```
