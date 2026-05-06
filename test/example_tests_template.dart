// Example unit test templates for this project.
//
// Copy the section you need into a real test file, then replace the
// placeholder class names, method names, and expectations with your own.
// The project’s current testing style uses:
// - flutter_test
// - mocktail
// - setUp() for fresh mocks per test
// - Arrange / Act / Assert comments
// - helper constants from `test/test_helpers.dart`

// ---------------------------------------------------------------------------
// 1) SERVICE TEST TEMPLATE
// ---------------------------------------------------------------------------
//
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:journal_app/test/test_helpers.dart';
// import 'package:journal_app/data/services/your_service.dart';
//
// class MockYourDependency extends Mock implements YourDependency {}
//
// void main() {
//   late MockYourDependency mockYourDependency;
//   late YourService service;
//
//   setUp(() {
//     mockYourDependency = MockYourDependency();
//     service = YourService(mockYourDependency);
//   });
//
//   group('YourService', () {
//     group('yourMethod', () {
//       test('returns success when the dependency succeeds', () async {
//         // Arrange
//         when(() => mockYourDependency.someMethod(
//               any(named: 'value'),
//             )).thenAnswer((_) async => TestDataBuilder.buildSuccessResult(true));
//
//         // Act
//         final result = await service.yourMethod(value: TestConstants.testUserName);
//
//         // Assert
//         expect(result.isSuccess, true);
//         expect(result.data, true);
//         expect(result.error, null);
//         verify(() => mockYourDependency.someMethod(
//               value: TestConstants.testUserName,
//             )).called(1);
//       });
//
//       test('returns failure when the dependency throws', () async {
//         // Arrange
//         when(() => mockYourDependency.someMethod(
//               any(named: 'value'),
//             )).thenThrow(Exception('boom'));
//
//         // Act
//         final result = await service.yourMethod(value: TestConstants.testUserName);
//
//         // Assert
//         expect(result.isSuccess, false);
//         expect(result.error, isNotNull);
//       });
//     });
//   });
// }

// ---------------------------------------------------------------------------
// 2) REPOSITORY TEST TEMPLATE
// ---------------------------------------------------------------------------
//
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:journal_app/test/test_helpers.dart';
// import 'package:journal_app/data/repositories/your_repository.dart';
// import 'package:journal_app/data/services/your_service.dart';
//
// class MockYourService extends Mock implements YourService {}
//
// void main() {
//   late MockYourService mockYourService;
//   late YourRepository repository;
//
//   setUp(() {
//     mockYourService = MockYourService();
//     repository = YourRepository(mockYourService);
//   });
//
//   group('YourRepository', () {
//     group('yourMethod', () {
//       test('returns success when service returns success', () async {
//         // Arrange
//         when(() => mockYourService.yourMethod(
//               value: any(named: 'value'),
//             )).thenAnswer((_) async => TestDataBuilder.buildSuccessResult(true));
//
//         // Act
//         final result = await repository.yourMethod(value: TestConstants.testUserName);
//
//         // Assert
//         expect(result.isSuccess, true);
//         expect(result.data, true);
//         verify(() => mockYourService.yourMethod(
//               value: TestConstants.testUserName,
//             )).called(1);
//       });
//
//       test('passes through failure without changing the error', () async {
//         // Arrange
//         final error = TestDataBuilder.buildApiError(
//           message: TestConstants.networkError,
//           statusCode: TestConstants.statusInternalServerError,
//         );
//         when(() => mockYourService.yourMethod(
//               value: any(named: 'value'),
//             )).thenAnswer((_) async => TestDataBuilder.buildFailureResult(
//               message: error.message,
//               statusCode: error.statusCode,
//             ));
//
//         // Act
//         final result = await repository.yourMethod(value: TestConstants.testUserName);
//
//         // Assert
//         expect(result.isSuccess, false);
//         expect(result.error?.message, error.message);
//         expect(result.error?.statusCode, error.statusCode);
//       });
//     });
//   });
// }

// ---------------------------------------------------------------------------
// 3) VIEWMODEL TEST TEMPLATE
// ---------------------------------------------------------------------------
//
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:journal_app/test/test_helpers.dart';
// import 'package:journal_app/network/api_error.dart';
// import 'package:journal_app/network/api_result.dart';
// import 'package:journal_app/network/api_status.dart';
// import 'package:journal_app/presentation/viewmodels/your_viewmodel.dart';
// import 'package:journal_app/data/repositories/your_repository.dart';
// import 'package:journal_app/data/services/local_storage_service.dart';
//
// class MockYourRepository extends Mock implements YourRepository {}
// class MockLocalStorageService extends Mock implements LocalStorageService {}
//
// void main() {
//   late MockYourRepository mockYourRepository;
//   late MockLocalStorageService mockLocalStorageService;
//   late YourViewModel viewModel;
//
//   setUp(() {
//     mockYourRepository = MockYourRepository();
//     mockLocalStorageService = MockLocalStorageService();
//     viewModel = YourViewModel(mockYourRepository, mockLocalStorageService);
//   });
//
//   group('YourViewModel', () {
//     group('yourAction', () {
//       test('updates state to loading then success', () async {
//         // Arrange
//         when(() => mockYourRepository.yourAction(
//               value: any(named: 'value'),
//             )).thenAnswer((_) async => ApiResult.success(true));
//         when(() => mockLocalStorageService.someSaveMethod(any()))
//             .thenAnswer((_) async => {});
//
//         // Act
//         final future = viewModel.yourAction(value: TestConstants.testUserName);
//
//         // Assert loading state
//         expect(viewModel.yourActionStatus, ApiStatus.loading);
//
//         final result = await future;
//
//         // Assert final state
//         expect(result, true);
//         expect(viewModel.yourActionStatus, ApiStatus.success);
//         expect(viewModel.yourActionErrorMessage, null);
//       });
//
//       test('updates state to error when repository fails', () async {
//         // Arrange
//         final error = ApiError(
//           message: TestConstants.invalidCredentialsError,
//           statusCode: TestConstants.statusUnauthorized,
//         );
//         when(() => mockYourRepository.yourAction(
//               value: any(named: 'value'),
//             )).thenAnswer((_) async => ApiResult.failure(error));
//
//         // Act
//         final result = await viewModel.yourAction(value: TestConstants.testUserName);
//
//         // Assert
//         expect(result, false);
//         expect(viewModel.yourActionStatus, ApiStatus.error);
//         expect(viewModel.yourActionErrorMessage, error.message);
//       });
//
//       test('handles side effects and storage failures safely', () async {
//         // Arrange
//         when(() => mockYourRepository.yourAction(
//               value: any(named: 'value'),
//             )).thenAnswer((_) async => ApiResult.success('token'));
//         when(() => mockLocalStorageService.someSaveMethod(any()))
//             .thenThrow(Exception('storage error'));
//
//         // Act
//         final result = await viewModel.yourAction(value: TestConstants.testUserName);
//
//         // Assert
//         expect(result, false);
//         expect(viewModel.yourActionStatus, ApiStatus.error);
//         expect(viewModel.yourActionErrorMessage, isNotNull);
//       });
//     });
//   });
// }

// ---------------------------------------------------------------------------
// QUICK TIPS
// ---------------------------------------------------------------------------
// - Use `TestConstants` for repeated usernames, passwords, tokens, and messages.
// - Use `TestDataBuilder.buildSuccessResult(...)` and `buildFailureResult(...)`
//   when you want concise test setup.
// - Prefer one mock class per dependency.
// - Keep tests in AAA order: Arrange, Act, Assert.
// - For async viewmodels, verify both the intermediate loading state and the
//   final state after awaiting the returned Future.

