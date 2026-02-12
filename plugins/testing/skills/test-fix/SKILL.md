---
name: test-fix
trigger: When the user has failing tests or asks about test failures
---

Diagnose why tests are failing and suggest the correct fix.

## Diagnostic Process

### 1. Read the Error Output

- Parse the test runner's error output carefully.
- Identify which test(s) are failing and the exact assertion or error message.
- Note the file paths, line numbers, and stack traces provided.

### 2. Examine the Test Code

- Read the failing test to understand what behavior it expects.
- Check the test setup (fixtures, mocks, beforeEach/setUp) for correctness.
- Verify that mocks and stubs are configured to return the expected values.
- Look for common test issues: stale snapshots, missing async/await, incorrect mock setup, wrong assertion matchers.

### 3. Examine the Implementation Under Test

- Read the source code being tested.
- Trace the execution path that the test exercises.
- Compare the actual behavior against what the test expects.

### 4. Identify the Root Cause

Classify the failure into one of these categories:

- **Implementation bug**: The source code has a defect. The test is correct and is catching a real problem. Fix the implementation.
- **Outdated test**: The implementation has changed intentionally, but the test was not updated to reflect the new behavior. Update the test.
- **Missing or incorrect mock**: An external dependency is not properly mocked, causing unexpected behavior. Fix the mock setup.
- **Environment issue**: The test depends on environment state (file system, network, database, environment variables, time) that is not properly controlled. Add appropriate setup or mocking.
- **Test isolation failure**: Tests are interfering with each other due to shared mutable state. Add proper cleanup or isolate the state.
- **Flaky test**: The test has a race condition, timing dependency, or non-deterministic element. Identify the source of flakiness and make the test deterministic.

### 5. Suggest the Fix

- Clearly state whether the bug is in the test or the implementation.
- Provide the specific code change needed to fix the issue.
- If the fix is in the implementation, verify that the fix does not break other tests.
- If the fix is in the test, verify that the updated test still validates meaningful behavior and is not simply "making the test pass" by weakening assertions.
