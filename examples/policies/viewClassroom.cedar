permit(
  principal,
  action in [
    Platform::Action::"viewClassroom"
  ],
  resource
)
when {
  resource in principal.organizationalUnit
};
