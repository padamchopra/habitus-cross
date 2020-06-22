enum HabitoAuth {
  SUCCESS,
  FAIL,
  VERIFICATION_REQUIRED,
  SIGNED_OUT,
  NO_USER,
  DELETED
}

enum HabitModalMode { NEW, VIEW, EDIT, DUPLICATE }

enum CategoryModalMode { NEW, VIEW, EDIT, DUPLICATE }

enum HabitSelectedOption { NONE, DUPLICATE_AND_EDIT, RESET_PROGRESS, DELETE }

enum CategorySelectedOption {
  NONE,
  VIEW_HABITS,
  EDIT,
  DUPLICATE_AND_EDIT,
  DELETE
}

enum HabitProgressChange { SUCCESS, UPDATED_TODAY, LATE, COMPLETE, FAIL }
