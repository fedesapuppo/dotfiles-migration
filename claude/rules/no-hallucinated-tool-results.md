# Never hallucinate tool results

When a subagent or tool call fails, returns an error, or returns no meaningful data:

1. **Acknowledge the failure explicitly** to the user
2. **Never pretend the data was received** — do not summarize, quote, or act on data that wasn't actually returned
3. **Retry with a corrected approach** or ask the user for help

## Common failure patterns to watch for

- Subagent says it called a tool but the output contains no actual response data
- Subagent tool name doesn't match available tools (e.g., `mcp__atlassian_jira__jira_get` vs `mcp__atlassian__jira_get`)
- Agent returns a template/placeholder instead of real data
- Tool result contains only the agent's narrative about what it "would" do

## Rule

If you cannot verify that real data was returned from a tool call, **stop and tell the user** rather than continuing with fabricated information.
