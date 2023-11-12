# astronomy_picture_of_the_day

<p align="center"> 
  <a href="https://www.nasa.gov/" align="right">
    <img width="156" alt="NASA icon"
    src="https://user-images.githubusercontent.com/24878574/282269386-1804fb09-3afe-4f05-9169-da18b36100a3.png">
  </a>
</p>

## Contents

- [Overview](#overview)
- [Getting Started](#getting-started)
- [Running the App](#running-the-app)
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

Running the app on one of the listed devices in debug mode:

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

## References

- [API NASA](https://api.nasa.gov/)
- [package by feature](https://phauer.com/2020/package-by-feature/)
- [package by feature, not layer](http://www.javapractices.com/topic/TopicAction.do?Id=205)
