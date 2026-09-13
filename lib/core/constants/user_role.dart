/// Which side of the marketplace the account is being created for —
/// chosen on [RoleSelectionScreen] and threaded through the shared
/// sign up / OTP flow so it can branch (e.g. providers verify identity
/// before reaching Home) without duplicating those screens per role.
enum UserRole { user, provider }
