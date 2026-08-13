# Strict Agent Execution Rules

1. **Strict Instruction Following:** Do EXACTLY what the user explicitly asks for.
2. **No Unsolicited Modifications:** DO NOT add extra features, extra files, extra dependencies, extra design changes, or extra modifications unless the user explicitly requests them.
3. **No Unrequested Refactoring:** DO NOT refactor, reorganize, or rewrite code outside the exact scope requested by the user.
4. **Minimal Direct Changes:** Make the exact required changes and nothing more.
5. **No Automatic APK Builds:** DO NOT build APK (`flutter build apk`) automatically after making code changes. Only build APK when the user explicitly requests "apk build karo" or similar.

