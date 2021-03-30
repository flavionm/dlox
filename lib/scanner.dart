import 'package:dlox/token.dart';

class Scanner {
  final String _source;
  final Function _errorReporter;

  final List<Token> _tokens = [];

  int _start = 0;
  int _current = 0;
  int _line = 1;

  bool _error = false;

  Scanner(this._source, this._errorReporter);

  List<Token>? scanTokens() {
    while (!_isAtEnd()) {
      _start = _current;
      _scanToken();
    }

    if (_error) {
      return null;
    } else {
      return _tokens;
    }
  }

  void _scanToken() {
    final c = _source[_current];
    _current++;
    switch (c) {
      case '(':
        _addToken(TokenType.LEFT_PAREN);
        break;
      case ')':
        _addToken(TokenType.RIGHT_PAREN);
        break;
      case '{':
        _addToken(TokenType.LEFT_BRACE);
        break;
      case '}':
        _addToken(TokenType.RIGHT_BRACE);
        break;
      case ',':
        _addToken(TokenType.COMMA);
        break;
      case '.':
        _addToken(TokenType.DOT);
        break;
      case '-':
        _addToken(TokenType.MINUS);
        break;
      case '+':
        _addToken(TokenType.PLUS);
        break;
      case ';':
        _addToken(TokenType.SEMICOLON);
        break;
      case '*':
        _addToken(TokenType.STAR);
        break;
      case '!':
        _addToken(_match('=') ? TokenType.BANG_EQUAL : TokenType.BANG);
        break;
      case '=':
        _addToken(_match('=') ? TokenType.EQUAL_EQUAL : TokenType.EQUAL);
        break;
      case '<':
        _addToken(_match('=') ? TokenType.LESS_EQUAL : TokenType.LESS);
        break;
      case '>':
        _addToken(_match('=') ? TokenType.GREATER_EQUAL : TokenType.GREATER);
        break;
      case '/':
        _scanComment();
        break;
      case '"':
        _scanString();
        break;
      case ' ':
      case '\r':
      case '\t':
        break;
      case '\n':
        _line++;
        break;
      default:
        _errorReporter(_line, 'Invalid character $c');
        _error = true;
    }
  }

  void _scanComment() {
    if (_match('/')) {
      while (_peek() != '\n' && !_isAtEnd()) {
        _current++;
      }
    } else {
      _addToken(TokenType.SLASH);
    }
  }

  void _scanString() {
    while (_peek() != '"' && !_isAtEnd()) {
      if (_peek() == '\n') _line++;
      _current++;
    }

    if (_isAtEnd()) {
      _errorReporter(_line, 'Unterminated string.');
      return;
    }

    _current++;

    _addToken(TokenType.STRING, _source.substring(_start + 1, _current - 1));
  }

  String _peek() {
    if (_isAtEnd()) return '\0';
    return _source[_current];
  }

  bool _match(String expected) {
    if (_peek() == expected) {
      _current++;
      return true;
    } else {
      return false;
    }
  }

  bool _isAtEnd() {
    return _current >= _source.length;
  }

  void _addToken(TokenType type, [Object? literal]) {
    final text = _source.substring(_start, _current);
    _tokens.add(Token(type, text, literal));
  }
}
