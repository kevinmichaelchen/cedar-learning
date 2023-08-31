[Cedar Agent][cedar-agent] is a great tool for running a Cedar server locally.

It offers a REST API for CRUD for your policies and entities data.

## Nice features

It's a simple API that comes with really nice [OpenAPI][swagger] docs and a [Playground][rapidoc].

[rapidoc]: http://localhost:8180/rapidoc
[swagger]: http://localhost:8180/swagger-ui

## Missing features

However, their feature set is currently missing support for Policy [Templates][templates] and
[Schemas][schema].

In addition, their REST API [expects][cedar-agent-policy-format] policies to be stringified and escaped. It would be nice if (as described in my GitHub [Issue][issue]) both the official `cedar` CLI could
support formatting policies as JSON, and `cedar-agent` could ingest that format.

[issue]: https://github.com/permitio/cedar-agent/issues/19
[cedar-agent]: https://github.com/permitio/cedar-agent
[cedar-agent-policy-format]: https://github.com/permitio/cedar-agent/blob/main/examples/policies.json
[templates]: https://docs.cedarpolicy.com/templates.html
[schema]: https://docs.cedarpolicy.com/schema.html
