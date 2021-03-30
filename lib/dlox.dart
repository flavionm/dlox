import 'dart:io';

import 'package:dlox/scanner.dart';

const EXIT_USAGE = 64;
const EXIT_DATAERROR = 65;

void start(List<String> arguments) {
  if (arguments.length > 1) {
    stderr.writeln('Too many positional arguments. Usage: dlox [script]');
    exitCode = EXIT_USAGE;
  } else if (arguments.length == 1) {
    runFile(arguments[0]);
  } else {
    runPrompt();
  }
}

void runFile(String scriptPath) {
  final script = File(scriptPath).readAsStringSync();
  final result = run(script);
  if (result == null) {
    exitCode = EXIT_DATAERROR;
  } else {
    stdout.write(result);
  }
}

void runPrompt() {
  while (true) {
    final input = stdin.readLineSync();
    if (input == null) break;

    final result = run(input);
    if (result != null) {
      stdout.writeln(result);
    }
  }
}

String? run(String source) {
  final tokens = Scanner(source, printError).scanTokens();
  if (tokens == null) {
    return null;
  } else {
    final buffer = StringBuffer();
    buffer.writeAll(tokens, '\n');
    return buffer.toString();
  }
}

void printError(int line, String message) {
  stderr.writeln('Line $line: $message');
}
