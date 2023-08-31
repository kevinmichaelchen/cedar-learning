# Formats policies so they're JSON-stringified
# and ingestible by cedar-agent
.PHONY: policies
policies:
	# Strip newlines
	sd \\n+ ' ' examples/policies/*.cedar
	# Condense whitespaces into one
	sd \\s+ ' ' examples/policies/*.cedar
	# Escape double-quotes
	sd \" '\\"' examples/policies/*.cedar
