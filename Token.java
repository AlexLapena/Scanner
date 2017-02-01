/*
  Alex Lapena
  Token.java
*/
class Token {

  public final static int ERROR = 0;
  public final static int OPEN = 1;
  public final static int CLOSE = 2;
  public final static int WORD = 3;
  public final static int NUMBER = 4;
  public final static int APOSTROPHIZED = 5;
  public final static int HYPHENATED = 6;
  public final static int PUNCTUATIONS = 7;
  public final static int DELIMETERS = 8;
  public final static int ELSE = 9;


  public int m_type;
  public String m_value;
  public int m_line;
  public int m_column;
  
  Token (int type, String value, int line, int column) {
    m_type = type;
    m_value = value;
    m_line = line;
    m_column = column;
  }

  public String toString() {
    switch (m_type) {
      case OPEN:
        return "OPEN-" + m_value;
      case CLOSE:
        return "CLOSE-" + m_value;
      case WORD:
        return "WORD(" + m_value + ")";
      case NUMBER:
        return "NUMBER(" + m_value+ ")";
      case APOSTROPHIZED:
        return "APOSTROPHIZED(" + m_value+ ")";
      case HYPHENATED:
        return "HYPHENATED(" + m_value+ ")";
      case PUNCTUATIONS:
        return "PUNCTUATIONS(" + m_value+ ")";
      case DELIMETERS:
        return "DELIMETERS(" + m_value+ ")";
      case ERROR:
        return "ERROR(" + m_value + ")";
      case ELSE:
        return "ELSE (" + m_value + ")";
      default:
        return "UNKNOWN(" + m_value + ")";
    }
  }
}

