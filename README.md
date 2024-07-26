# Transcodex

A basic command line utility for transcoding files such as (.heic) to (.jpeg) written in the [Swift](https://www.swift.org/) programming language.

|Dependencies|Version|
|------------|-------|
|[Swift](https://www.swift.org/install)|5.10|

## Installation

Please make sure you have Swift installed on your local machine, to do this on Linux you can follow this guide:

```bash
sudo apt update
sudo apt install clang libicu-dev build-essential pkg-config
```

https://www.swift.org/documentation/server/guides/deploying/ubuntu.html

## Basic Usage

Run the following command to download and build this tool for your platform

```bash
git clone https://github.com/asleepace/transcodex
cd transcodex
swift build

# to run the program
swift run transcodex --source ./example.heic
```
