# Unit Testing Guide for Journal App

This guide explains how to write unit tests for different layers of the Flutter project using the established testing framework.

## Table of Contents

1. [Setup](#setup)
2. [Testing Framework](#testing-framework)
3. [Testing Layers](#testing-layers)
4. [Running Tests](#running-tests)
5. [Best Practices](#best-practices)
6. [Examples](#examples)

## Setup

### Dependencies Added

The following testing dependencies have been added to `pubspec.yaml`:

- **flutter_test**: Flutter's testing framework (included with Flutter SDK)
- **mocktail**: A mocking library that creates mock objects for testing
- **mockito**: An alternative mocking library (available if needed)

### Installation

Run the following command to fetch the new dependencies:

```bash
flutter pub get
```

## Testing Framework

### Mocktail vs Mockito

This project uses **mocktail** as the primary mocking library because:

- **Simpler API**: More intuitive syntax for creating and verifying mocks
- **Better Null Safety Support**: Works seamlessly with Dart's null safety
- **Easier to Use**: Fewer boilerplate requirements
- **Modern Approach**: Specifically designed for modern Dart/Flutter development

### Mocktail Basics

```dart
import 'package:mocktail/mocktail.dart';

// 1. Create a mock class
class MockStringBuffer extends Mock implements StringBuffer {}

// 2. Create an instance in setUp
final mockBuffer = MockStringBuffer();

// 3. Set up behavior with when()
when(() => mockBuffer.write(any())).thenAnswer((_) async => {});

// 4. Verify calls with verify()
verify(() => mockBuffer.write('hello')).called(1);
```

## Testing Layers

### 1. Service Layer Tests (API Services)

**Location**: `test/data/services/`

**Purpose**: Test API calls, error handling, and response parsing

**Key Points**:
- Mock external dependencies (Dio, HTTP client)
- Test success and failure scenarios
- Verify correct API endpoints and parameters
- Test error handling and edge cases

**Example**: See `test/data/services/auth_api_service_test.dart`

```dart
test('returns success when signup API call succeeds', () async {
  // Arrange
  when(() => mockDio.post(
    any(),
    data: any(named: 'data'),
  )).thenAnswer((_) async => Response(...));

  // Act
  final result = await authApiService.signUp(...);

  // Assert
  expect(result.isSuccess, true);
  verify(() => mockDio.post(...)).called(1);
});
```

### 2. Repository Layer Tests

**Location**: `test/data/repositories/`

**Purpose**: Test business logic and service orchestration

**Key Points**:
- Mock the service layer
- Test that repositories correctly delegate to services
- Verify parameters are passed correctly
- Test result transformation if any

**Example**: See `test/data/repositories/auth_repository_test.dart`

```dart
test('returns success when service returns success', () async {
  // Arrange
  when(() => mockAuthApiService.signUp(...))
    .thenAnswer((_) async => ApiResult.success(true));

  // Act
  final result = await authRepository.signUp(...);

  // Assert
  expect(result.isSuccess, true);
});
```

### 3. ViewModel Layer Tests

**Location**: `test/presentation/viewmodels/`

**Purpose**: Test state management and business logic

**Key Points**:
- Mock repository and service dependencies
- Test state transitions (loading → success/error)
- Verify listeners are notified on state changes
- Test error message handling
- Test edge cases and error scenarios

**Example**: See `test/presentation/viewmodels/auth_viewmodel_test.dart`

```dart
test('updates state to loading then success when signup succeeds', () async {
  // Arrange
  when(() => mockAuthRepository.signUp(...))
    .thenAnswer((_) async => ApiResult.success(true));

  // Act
  final future = authViewModel.signUp(...);
  expect(authViewModel.signUpApiStatus, ApiStatus.loading);
  final result = await future;

  // Assert
  expect(result, true);
  expect(authViewModel.signUpApiStatus, ApiStatus.success);
});
```

### 4. Utility/Helper Tests

**Location**: `test/`

**Purpose**: Test utility functions and extensions

**Example**: See `test/date_helper_test.dart`

```dart
test('formats a valid ISO date string', () {
  expect('2026-05-04'.formatDate(), '04/05/2026');
});
```

## Running Tests

### Run All Tests

```bash
flutter test
```

### Run Tests in a Specific File

```bash
flutter test test/data/services/auth_api_service_test.dart
```

### Run Tests Matching a Pattern

```bash
flutter test --name "AuthViewModel"
```

### Run Tests with Code Coverage

```bash
flutter test --coverage
```

View the coverage report:
```bash
open coverage/lcov.html  # macOS
```

### Watch Mode (Re-run on File Changes)

```bash
flutter test --watch
```

## Best Practices

### 1. Test Structure (AAA Pattern)

Every test should follow the Arrange-Act-Assert pattern:

```dart
test('description of what is being tested', () async {
  // ARRANGE: Set up test data and mocks
  when(() => mockService.method()).thenAnswer((_) async => result);

  // ACT: Execute the code being tested
  final outcome = await functionUnderTest();

  // ASSERT: Verify the results
  expect(outcome, expectedValue);
  verify(() => mockService.method()).called(1);
});
```

### 2. Clear Test Names

Use descriptive test names that explain:
- What is being tested
- What condition is being tested
- What the expected outcome is

```dart
// Good
test('returns success when login API call succeeds', () {});
test('returns error when network is unavailable', () {});

// Bad
test('login works', () {});
test('error handling', () {});
```

### 3. One Assertion Focus

Each test should primarily focus on one aspect, though multiple assertions for the same concept are okay:

```dart
// Good - tests one behavior
test('returns success and sets token', () async {
  final result = await login();
  expect(result.isSuccess, true);
  expect(result.data, token);
});

// Avoid - tests multiple unrelated behaviors
test('login works and database updates', () async {
  // Tests login AND database updates - split into two tests
});
```

### 4. Use Test Groups

Organize related tests using `group()`:

```dart
group('AuthViewModel', () {
  group('login', () {
    test('returns success when credentials are valid', () {});
    test('returns error when credentials are invalid', () {});
  });

  group('logout', () {
    test('clears stored tokens', () {});
  });
});
```

### 5. Mock Only Dependencies

Mock only external dependencies and interfaces, not the class being tested:

```dart
// Good
class AuthRepository {
  // Mock this - it's a dependency
  AuthApiService _apiService;
}

// Bad - don't mock AuthRepository if you're testing it
```

### 6. Test Edge Cases

Always include tests for:
- Happy path (success cases)
- Error cases (API failures)
- Edge cases (empty inputs, null values, etc.)
- Boundary conditions

```dart
test('returns failure when response is empty', () {});
test('returns failure when token is null', () {});
test('handles network timeout gracefully', () {});
```

### 7. Use Test Helpers

Use the `test_helpers.dart` file for shared test data:

```dart
import 'package:journal_app/test_helpers.dart';

test('login with test credentials', () async {
  final result = await login(
    userName: TestConstants.testUserName,
    password: TestConstants.testPassword,
  );
  expect(result, isNotNull);
});
```

### 8. Clean Up Resources

Use `setUp()` and `tearDown()` to manage test lifecycle:

```dart
setUp(() {
  mockService = MockService();
  viewModel = AuthViewModel(mockService);
});

tearDown(() {
  // Clean up if needed
});
```

## Examples

### Writing a New Service Test

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:journal_app/data/services/home_api_service.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late HomeApiService homeApiService;

  setUp(() {
    mockDio = MockDio();
    homeApiService = HomeApiService(mockDio);
  });

  group('HomeApiService', () {
    test('fetches journals successfully', () async {
      // Arrange
      when(() => mockDio.get(any()))
        .thenAnswer((_) async => Response(
          data: [/* journal data */],
          statusCode: 200,
        ));

      // Act
      final result = await homeApiService.getJournals();

      // Assert
      expect(result.isSuccess, true);
    });
  });
}
```

### Writing a New Repository Test

```dart
void main() {
  late MockHomeApiService mockService;
  late HomeRepository repository;

  setUp(() {
    mockService = MockHomeApiService();
    repository = HomeRepository(mockService);
  });

  group('HomeRepository', () {
    test('returns journals from service', () async {
      // Arrange
      final journals = [/* test journals */];
      when(() => mockService.getJournals())
        .thenAnswer((_) async => ApiResult.success(journals));

      // Act
      final result = await repository.getJournals();

      // Assert
      expect(result.data, journals);
    });
  });
}
```

### Writing a New ViewModel Test

```dart
void main() {
  late MockHomeRepository mockRepository;
  late HomeViewModel viewModel;

  setUp(() {
    mockRepository = MockHomeRepository();
    viewModel = HomeViewModel(mockRepository);
  });

  group('HomeViewModel', () {
    test('loads journals and updates state', () async {
      // Arrange
      when(() => mockRepository.getJournals())
        .thenAnswer((_) async => ApiResult.success([]));

      // Act
      await viewModel.loadJournals();

      // Assert
      expect(viewModel.journalsLoadingStatus, ApiStatus.success);
    });
  });
}
```

## Future Improvements

As you expand testing coverage, consider:

1. **Widget Tests**: Test UI components and user interactions
2. **Integration Tests**: Test full user workflows
3. **Golden Tests**: Test visual consistency of widgets
4. **Performance Tests**: Measure and optimize performance

## Resources

- [Flutter Testing Documentation](https://flutter.dev/docs/testing)
- [Mocktail Documentation](https://pub.dev/packages/mocktail)
- [Mockito Documentation](https://pub.dev/packages/mockito)
- [Testing Best Practices](https://codewithandrea.com/articles/flutter-unit-tests/)

