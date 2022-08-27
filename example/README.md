# example

A new Flutter project.

## Getting Started

I recommend opening the whole workspace in VS Code by calling:

```sh
code .
```

You will see the following directories:

- `example` - our application
- `camera_view` - federated plugin
  - `camera_view` - Dart implementation of the interface and widgets
  - `camera_view_platform_interface` - a common platform interface for the `camera_view` plugin
  - `camera_view_xxx` - platform implementations of the plugin

Try it out by running the example app on your desired device (iOS, Android, or macOS).

## Camera details

This sample hosts camera previews on the following platforms:

| Platform | Support |
| -------- | ------- |
| iOS      | Yes     |
| Android  | Yes     |
| macOS    | Yes     |
| Windows  | No      |
| Linux    | No      |
| Web      | No      |

The iOS and macOS implementations use SwiftUI camera views from [this article](https://www.raywenderlich.com/26244793-building-a-camera-app-with-swiftui-and-combine) by Yono Mittlefehldt. The license note is included in every file copied from the original implementation.

## Contributing

Contributions are welcome! If you'd like to improve existing implementation or propose new platform to be supported, please go ahead!
