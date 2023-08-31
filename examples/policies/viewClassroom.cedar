permit(
  principal,
  action in [
    Platform::Action::"viewClassroom"
  ],
  resource
)
when {
  principal has "organizationalUnit" &&
  (
    // when they're a teacher
    (
      principal has "isTeacher" && principal in resource
    ) ||

    // OR
    // when they're NOT a teacher
    (
      !(principal has "isTeacher") && resource in principal.organizationalUnit
    )
  )
};
