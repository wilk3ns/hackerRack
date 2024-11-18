
# Hacker Rack



A Flutter application that provides a clean and user friendly interface for browsing Hacker News content. Built as part of a technical assessment.



## Project Overview



This Hacker News client allows users to:

- Browse top stories

- View story details

- Check author profiles, their posts and comments

- Open links in an integrated web view and in the default external browser

- Offline support with local caching, with shared preferences

- Pull-to-refresh functionality



## Architecture & Technical Decisions



I tried to strike a balance between fully implementing the clean architecture, keeping the codebase maintainable and also make it simple, but not primitive. So it is neither fully clean, nor primitive.

The project follows clean architecture principles with three main layers:



```

lib/

├── data/ # Data layer - API & caching implementation

├── domain/ # Domain layer - Business logic & interfaces

└── presentation/ # UI layer - Screens & widgets

```





1.  **Data Layer**

- Handles API communication and local caching

- Uses Dio with Retrofit for network calls

- Implements SharedPreferences for local storage



2.  **Domain Layer**

- Contains business logic and use cases

- Defines repository interfaces

- Handles data transformation



3.  **Presentation Layer**

- Manages UI components and state

- Implements Material Design

- Uses Go Router for navigation



### State Management

Riverpod for state management is chosen because:

- Clean dependency injection capabilities

- Excellent testing support

- Type-safe provider creation

- Great developer experience with code generation

- And also because it was a requirement for the assessment



### Testing

The project includes unit tests focusing on:

- Repository implementation (API calls and caching)

- Provider functionality

- Uses Mockito for dependency mocking



## Areas for Future Improvement



### Testing Coverage

- Add widget tests for UI components

- Implement integration tests

- Increase unit test coverage



### Error Handling

- Implement more specific error messages

- Add retry mechanisms

- Improve offline mode handling



### UI/UX

- Add dark mode support

- Implement animations

- Enhance loading states

- Add pull-to-refresh feedback



### Performance

- Optimize pagination

- Improve caching strategies

- Add image caching



## Getting Started



### Prerequisites

- Flutter SDK

- Dart SDK

- An IDE (VS Code or Android Studio)



### Installation



1. Clone the repository

```bash

git clone https://github.com/wilk3ns/hackerRack.git

```



2. Install dependencies

```bash

flutter pub get

```



3. Run code generation

```bash

dart run build_runner build

```



4. Run the app

```bash

flutter run

```



### Running Tests

```bash

flutter  test

```



## Future Improvements



- [ ] Increase test coverage with widget and integration tests

- [ ] Add proper dark mode support

- [ ] Implement animations for better UX

- [ ] Optimize caching strategy

- [ ] Add pull-to-refresh indicators

- [ ] Improve error handling and offline support

- [ ] Add proper documentation

- [ ] I prefer using Database for caching, but it was not a requirement, so I used shared preferences



## Dependencies



Key dependencies include:

```yaml

dependencies:

flutter_riverpod:  ^2.6.1

dio:  ^5.7.0

retrofit:  ^4.4.1

freezed:  ^2.5.7

go_router:  ^14.6.0

shared_preferences:  ^2.3.3

webview_flutter:  ^4.10.0

dartz:  ^0.10.1

dev_dependencies:

mockito:  ^5.4.4

build_runner:  ^2.4.13

```



For a complete list of dependencies, see the `pubspec.yaml` file.



## License



This project is currently proprietary.