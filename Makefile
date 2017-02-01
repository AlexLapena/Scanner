JAVAC=javac
JFLEX=jflex

all: Scanner.class

Scanner.class: Scanner.java Lexer.java Token.java

%.class: %.java
	$(JAVAC) $^ 

Lexer.java: sgml.flex
	$(JFLEX) sgml.flex 

clean:
	rm -f Lexer.java *.class *~
