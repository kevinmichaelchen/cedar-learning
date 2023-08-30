permit(
  principal in Role::"Admin",
  action in [
    Action::"get",
    Action::"list",
    Action::"update",
    Action::"create",
    Action::"delete"
  ],
  resource == Document::"cedar-agent.pdf"
);
