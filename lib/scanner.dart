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
        _addToken(TokenType.LEFT_PAREN, null);
        break;
      case ')':
        _addToken(TokenType.RIGHT_PAREN, null);
        break;
      case '{':
        _addToken(TokenType.LEFT_BRACE, null);
        break;
      case '}':
        _addToken(TokenType.RIGHT_BRACE, null);
        break;
      case ',':
        _addToken(TokenType.COMMA, null);
        break;
      case '.':
        _addToken(TokenType.DOT, null);
        break;
      case '-':
        _addToken(TokenType.MINUS, null);
        break;
      case '+':
        _addToken(TokenType.PLUS, null);
        break;
      case ';':
        _addToken(TokenType.SEMICOLON, null);
        break;
      case '*':
        _addToken(TokenType.STAR, null);
        break;
      case '!':
        _addToken(_match('=') ? TokenType.BANG_EQUAL : TokenType.BANG, null);
        break;
      case '=':
        _addToken(_match('=') ? TokenType.EQUAL_EQUAL : TokenType.EQUAL, null);
        break;
      case '<':
        _addToken(_match('=') ? TokenType.LESS_EQUAL : TokenType.LESS, null);
        break;
      case '>':
        _addToken(
            _match('=') ? TokenType.GREATER_EQUAL : TokenType.GREATER, null);
        break;
      case '/':
        if (_match('/')) {
          _scanComment();
        } else {
          _addToken(TokenType.SLASH, null);
        }
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
        if (_isDigit(c)) {
          _scanNumber();
        } else {
          _errorReporter(_line, 'Invalid character $c');
          _error = true;
        }
    }
  }

  void _scanComment() {
    while (_peek() != '\n' && !_isAtEnd()) {
      _current++;
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

  bool _isDigit(String c) {
    return RegExp('^[0-9]').hasMatch(c);
  }

  void _scanNumber() {
    while (_isDigit(_peek())) {
      _current++;
    }

    if (_peek() == '.' && _isDigit(_peekNext())) {
      _current++;
      while (_isDigit(_peek())) {
        _current++;
      }
    }

    _addToken(
        TokenType.NUMBER, double.parse(_source.substring(_start, _current)));
  }

  String _peek() {
    if (_isAtEnd()) return '\u0000';
    return _source[_current];
  }

  String _peekNext() {
    final next = _current + 1;
    if (next == _source.length) return '\u0000';
    return _source[next];
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

  void _addToken<T>(TokenType type, T literal) {
    final text = _source.substring(_start, _current);
    _tokens.add(Token<T>(type, text, literal));
  }
}
