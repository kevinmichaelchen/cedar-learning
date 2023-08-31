permit(
  principal in Platform::Teacher,
  action in [
    Platform::Action::"viewClassroom"
  ],
  resource in Platform::Classroom
)
when {
  resource in principal.organizationalUnit
};
