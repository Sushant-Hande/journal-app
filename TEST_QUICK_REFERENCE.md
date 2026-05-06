# Quick Reference - Test Commands

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Tests with Verbose Output
```bash
flutter test -v
```

### Run Specific Test File
```bash
flutter test test/data/services/auth_api_service_test.dart
```

### Run Tests Matching a Name
```bash
flutter test --name "login"
flutter test --name "AuthViewModel"
```

### Run Tests in Watch Mode (Re-run on file changes)
```bash
flutter test --watch
```

### Run Tests with Code Coverage
```bash
flutter test --coverage
```

### View Coverage Report (macOS)
```bash
open coverage/lcov.html
```

## Project Test Structure

```
test/
├── test_helpers.dart                    # Shared test utilities and constants
├── date_helper_test.dart                # Utility function tests
├── data/
│   ├── services/
│   │   └── auth_api_service_test.dart   # API service layer tests
│   └── repositories/
│       └── auth_repository_test.dart    # Repository layer tests
└── presentation/
    └── viewmodels/
        └── auth_viewmodel_test.dart     # ViewModel/state management tests
```

## Writing Tests - Quick Template

### Service Layer
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late YourApiService service;

  setUp(() {
    mockDio = MockDio();
    service = YourApiService(mockDio);
  });

  group('YourApiService', () {
    test('description of test', () async {
      // Arrange
      when(() => mockDio.get(any()))
          .thenAnswer((_) async => Response(data: ...));

      // Act
      final result = await service.method();

      // Assert
      expect(result.isSuccess, true);
    });
  });
}
```

### Repository Layer
```dart
class MockYourApiService extends Mock implements YourApiService {}

void main() {
  late MockYourApiService mockService;
  late YourRepository repository;

  setUp(() {
    mockService = MockYourApiService();
    repository = YourRepository(mockService);
  });

  group('YourRepository', () {
    test('delegates to service correctly', () async {
      when(() => mockService.getData())
          .thenAnswer((_) async => ApiResult.success(data));

      final result = await repository.getData();

      expect(result.isSuccess, true);
      verify(() => mockService.getData()).called(1);
    });
  });
}
```

### ViewModel Layer
```dart
class MockYourRepository extends Mock implements YourRepository {}
class MockLocalStorage extends Mock implements LocalStorageService {}

void main() {
  late MockYourRepository mockRepository;
  late MockLocalStorage mockStorage;
  late YourViewModel viewModel;

  setUp(() {
    mockRepository = MockYourRepository();
    mockStorage = MockLocalStorage();
    viewModel = YourViewModel(mockRepository, mockStorage);
  });

  group('YourViewModel', () {
    test('updates state on successful API call', () async {
      when(() => mockRepository.getData())
          .thenAnswer((_) async => ApiResult.success(data));

      final future = viewModel.loadData();
      expect(viewModel.isLoading, true);

      await future;
      expect(viewModel.isLoading, false);
      expect(viewModel.data, data);
    });
  });
}
```

## Key Testing Tips

1. **Use AAA Pattern**: Arrange, Act, Assert
2. **Clear Naming**: Test names should describe what and why
3. **One Focus**: Each test should verify one behavior
4. **Use Groups**: Organize related tests with `group()`
5. **Mock Dependencies**: Only mock external/injected dependencies
6. **Test Edge Cases**: Error scenarios, null values, empty lists
7. **Verify Interactions**: Use `verify()` to ensure correct calls

## Common Mocktail Methods

```dart
// Setup mock behavior
when(() => mock.method()).thenAnswer((_) async => value);
when(() => mock.method()).thenThrow(Exception('error'));

// Verify calls
verify(() => mock.method()).called(1);
verify(() => mock.method(any())).called(greaterThan(0));

// Match any argument
when(() => mock.method(any())).thenAnswer(...);
when(() => mock.method(any(named: 'param'))).thenAnswer(...);

// Setup return value for sync methods
when(() => mock.getter).thenReturn(value);
```

## Next Steps

1. **Add tests for HomeApiService** - See `test/data/services/auth_api_service_test.dart` as reference
2. **Add tests for remaining repositories** - Use `test/data/repositories/auth_repository_test.dart` as template
3. **Add tests for other viewmodels** - Use `test/presentation/viewmodels/auth_viewmodel_test.dart` as reference
4. **Set up CI/CD** - Run tests automatically on git push
5. **Increase coverage** - Aim for >80% code coverage

## Resources

- [Flutter Testing Docs](https://flutter.dev/docs/testing)
- [Mocktail Pub Dev](https://pub.dev/packages/mocktail)
- [Testing Best Practices](https://codewithandrea.com/articles/flutter-unit-tests/)

