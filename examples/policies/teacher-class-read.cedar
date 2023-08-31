permit(
  principal in Platform::Teacher,
  action in [
    Platform::Action::"viewClassroom"
  ],
  resource in ?resource
)
when {
  resource in principal.organizationalUnit
};
