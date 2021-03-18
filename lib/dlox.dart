import 'dart:io';

const int EXIT_USAGE = 64;

void start(List<String> arguments) {
  if (arguments.length > 1) {
    stderr.writeln('Too many positional arguments. Usage: dlox [script]');
    exit(EXIT_USAGE);
  } else if (arguments.length == 1) {
    runFile(arguments[0]);
  } else {
    runPrompt();
  }
}

void runFile(String scriptPath) {
  final script = File(scriptPath).readAsStringSync();
  print(run(script));
}

void runPrompt() {
  while (true) {
    final input = stdin.readLineSync();
    if (input == null) break;
    print(run(input));
  }
}

String run(String source) {
  return source;
}
