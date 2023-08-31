<p align="center">
  <img src="./forest.jpg" width="600" />
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

Check out the [**docs**](./docs) folder for details.

![students](./docs/4-students.svg)

### Who can view Hogwarts classrooms?

The answer is as you'd expect:

- Teachers or administrators of _Hogwarts School of Witchcraft and Wizardry_ can view classrooms at Hogwarts.
- Employees (teachers or admins) of any Hogwarts parent org units (e.g., the Ministry of Magic) can view Hogwarts classrooms.
- Employees of other schools cannot view Hogwarts classrooms.

```shell
for i in \
  Platform::Admin::\"dumbledore@hogwarts.edu\" \
  Platform::Teacher::\"snape@hogwarts.edu\" \
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

If we run the same checks, but for `beauxbatons_potions`, we'll notice the inverse: only teachers or admins of _Beauxbatons Academy of Magic_ can view its classrooms.

## Further Research

- Policy [Templates][templates]
  - We can't write a distinct policy for every principal/resource combination. That would be crazy
- One-liner to stringify all policies into one JSON file
- Calling this from Golang services?

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
