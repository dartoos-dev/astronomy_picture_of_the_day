# astronomy_picture_of_the_day

<p align="center"> 
  <a href="https://www.nasa.gov/" align="right">
    <img width="156" alt="NASA icon"
    src="https://user-images.githubusercontent.com/24878574/282269386-1804fb09-3afe-4f05-9169-da18b36100a3.png">
  </a>
</p>

[![license](https://img.shields.io/badge/license-mit-green.svg)](https://github.com/dartoos-dev/astronomy_picture_of_the_day/blob/master/LICENSE)
[![build](https://github.com/dartoos-dev/astronomy_picture_of_the_day/actions/workflows/build.yml/badge.svg)](https://github.com/dartoos-dev/astronomy_picture_of_the_day/actions/)
[![codecov](https://codecov.io/gh/dartoos-dev/astronomy_picture_of_the_day/branch/master/graph/badge.svg?token=W6spF0S796)](https://codecov.io/gh/dartoos-dev/astronomy_picture_of_the_day)
[![CodeFactor Grade](https://img.shields.io/codefactor/grade/github/rafamizes/astronomy_picture_of_the_day)](https://www.codefactor.io/repository/github/rafamizes/astronomy_picture_of_the_day)
[![style: lint](https://img.shields.io/badge/style-lint-4BC0F5.svg)](https://pub.dev/packages/lint)
[![Hits-of-Code](https://hitsofcode.com/github/dartoos-dev/astronomy_picture_of_the_day?branch=master)](https://hitsofcode.com/github/dartoos-dev/astronomy_picture_of_the_day/view?branch=master)
[![DevOps By
Rultor.com](https://www.rultor.com/b/dartoos-dev/astronomy_picture_of_the_day)](https://www.rultor.com/p/dartoos-dev/astronomy_picture_of_the_day)

## Contents

- [Overview](#overview)
- [Getting Started](#getting-started)
- [Running the App](#running-the-app)
- [Main Application Features](#main-application-features)
- [Project Structure Overview](#project-structure-overview)
  - [Project Architecture](#project-architecture)
  - [Directory Structure](#directory-structure)
  - [Package by feature](#package-by-feature)
- [Core Third-Party Packages](#core-third-party-packages)
- [References](#references)

## Overview

This is a Flutter app project to display NASA's astronomy picture of the day.

## Getting Started

This project is a fully functional example, focussed on showing
astronomy-related images by making http requests to NASA's public APIs.

You can take the code in this project and experiment with it.

```shell
  git clone https://github.com/dartoos-dev/astronomy_picture_of_the_day.git
  cd astronomy_picrture_of_the_day
```

## Running the App

As it is a Flutter project, you can run it on different platforms — Android,
IoS, Web, etc. But before running the application, you need to know which
devices are connected to your computer; you can achieve this by listing all
devices with the following terminal command:

```shell
  flutter devices
```

The above command will display a list similar to:

<p align="center">
  <img alt="list of connected devices"
  src="https://user-images.githubusercontent.com/24878574/282270845-2ea519df-9136-4d23-96f9-15fde7c53e88.png">
</p>

For example, to run the app on one of the listed devices in debug mode:

#### Android

```shell
  flutter run -d RQCW70
```

#### IoS

```shell
  flutter run -d 257E76
```

#### Chrome

```shell
  flutter run -d chrome
```

## Main Application Features

- List of astronomy pictures of the day retrieved from NASA's public API.
- Detail page of selected picture.
- Pull-to-refresh capability.
- Pagination.
- Automatically retries http requests when the device connection is intermittent
  or the server is offline at the time of the request — it uses an exponential
  backoff algorithm to retry the failed requests.
- It still works when offline.

## Project Structure Overview

### Project Architecture

- Clean Architecture

### Directory Structure

```shell
lib  
└───features  
│   └───feature1  
│   │  	└───sub_feature  
│   │   └───data  
│   │   └───domain  
│   │   └───external  
│   │   └───presenter  
│   └───feature2  
│   │  	└───sub_feature  
│   │  	└───data  
│   │  	└───domain  
│   │  	└───external  
│   │  	└───presenter  
└───shared  
│   app_module.dart  
│   app_widget.dart 
│   main.dart 
```

### Package by feature

In regard to packages or modules, this project uses the "package-by-feature"
approach rather than the more usual "package-by-layer". The former uses
packages to reflect the feature set; it places all items related to a single
feature into a single directory whose name corresponds to important, high-level
aspects of the problem domain.

It is important to note that package-by-feature style still honors the idea of
separating layers, but that separation is implemented using **separate
classes**.

#### Advantages of package by feature

- easy and logical code navigation — all items needed for a task are usually in
  the same directory.
- emphasis on core services rather than implementation details.
- scope minimization (package-private as default, not public as in package-by-layer).
- low coupling between modules.
- scalability: the number of classes remains limited to the items related
  to a specific feature.

#### Drawbacks of package by layer

- poor overview of all classes that belong to a feature.
- complex, hard to understand, and easy to break code as impact of a change is
  hard to grasp.
- leads to central classes containing all methods for every use case. Over time,
  those methods get bigger (with extra parameters) to fulfill more use cases.

## Core Third-Party Packages

- [dartz](https://pub.dev/packages/dartz): functional library.
- [dio](https://pub.dev/packages/dio): http client library.
- [flutter_modular](https://pub.dev/packages/flutter_modular): dependency injection and routing.
- [lint](https://pub.dev/packages/lint): stricter static analysis rules.
- [localization](https://pub.dev/packages/localization): simplifies in-app translation.
- [mocktail](https://pub.dev/packages/mocktail): mock framework for unit testing purposes.

## References

- [API NASA](https://api.nasa.gov/)
- [Clean Dart](https://github.com/Flutterando/Clean-Dart)
- [package by feature](https://phauer.com/2020/package-by-feature/)
- [package by feature, not layer](http://www.javapractices.com/topic/TopicAction.do?Id=205)
