/*
  Alex Lapena
  29 January 2017
  File Name: sgml.flex  
*/

import java.util.*;
import java.util.regex.Matcher;  
import java.util.regex.Pattern;
import java.lang.String.*;

%%
   
%class Lexer
%type Token
%line
%column

LineTerminator = \r|\n|\r\n
delimeters = {LineTerminator} | [ \t\f]
openTag = <[a-zA-Z0-9 ]+[a-zA-Z0-9 \"=]*>
closeTag = <\/[a-zA-Z0-9 ]+>
word = [0-9]*[a-zA-Z]+[0-9]*(\b)*
number = \+?\-?[0-9]+\.?[0-9]*
apostrophized = [a-zA-Z]+("'"[a-zA-Z]*)+
hyphenated = [a-zA-Z0-9]+("-"[a-zA-Z0-9]+)+
punctuations = [^\w\s\n ]

%{
    List<String> rTag = Arrays.asList("text", "date", "doc", "docno", "headline", "length", "p");
    Stack<String> globalStack = new Stack<String>();
    List<String> errs = new ArrayList<String>();
    public String baseTag = "";
    String str, str2;
    public int relevency = 0;

    private void stackManager(String closer, int line)
    {
        if (globalStack.isEmpty()) {
            errs.add("Error: Closing tag \"" + closer + "\" at line " + line + " is unexpected.");
            return;
        }

        if (closer.equalsIgnoreCase(globalStack.peek())) {
            globalStack.pop();
        }
        else {
            errs.add("Error: Expected closing tag \""+ globalStack.peek() + "\" at line " + line + " but recieved \"" + closer +"\".");
        }

    }

    private boolean isRelevent(String tag) {
        //find a way to filter out tags until you can pop everything off to be relevent
        if (rTag.contains(tag.toLowerCase())) {
            relevency = 0;
            return true;
        }
        else {
            baseTag = tag;
            relevency = 1;
            return false;
        }
    }

    public void checkIrrNest(String closeBase) 
    {
        if (closeBase.equalsIgnoreCase(baseTag)) {
            baseTag = "";
            relevency = 0;
        }
    }
%}

%eofval{
    for (int i = 0; i < errs.size(); i++) {
        System.err.println(errs.get(i));
    }
    return null;
%eofval};

   
%%
   
{openTag}           { 
                        // Identifies tag name and pushes onto global stack
                        str = new String(yytext());
                        Pattern pattern = Pattern.compile("<(.*?)>");
                        Matcher matcher = pattern.matcher(str);
                        if (matcher.find()) {
                            //Remove tag attributes
                            str2 = new String(matcher.group(1).replaceAll("\\s+", ""));
                            if (relevency == 0) {
                                if (isRelevent(str2)) {
                                    globalStack.push(str2);
                                    return new Token(Token.OPEN, str2, yyline, yycolumn);
                                }
                            }
                        }
                     }


{closeTag}          { 
                        // Identifies closing tag name and sends to stackManager() to compare
                        str = new String(yytext());
                        Pattern pattern = Pattern.compile("<(.*?)>");
                        Matcher matcher = pattern.matcher(str);
                        if (matcher.find()) {
                            str2 = new String(matcher.group(1).replaceAll("[/\\s+]", ""));
                            if(relevency == 0) {
                                if (isRelevent(str2)) { 
                                    stackManager(str2, yyline);
                                    return new Token(Token.CLOSE, str2, yyline,yycolumn); 
                                }
                            }
                            else {
                                checkIrrNest(str2);
                            }
                        }
                    }

{word}              {
                        if (relevency == 0) { 
                            return new Token(Token.WORD, yytext(), yyline, yycolumn);
                        } 
                    }

{number}            {
                        if (relevency == 0) { 
                            return new Token(Token.NUMBER, yytext(), yyline, yycolumn); 
                        }
                    }

{punctuations}      {
                        if (relevency == 0) { 
                            return new Token(Token.PUNCTUATIONS, yytext(), yyline, yycolumn);
                        }
                    }

{apostrophized}     { 
                        if (relevency == 0) { 
                            return new Token(Token.APOSTROPHIZED, yytext(), yyline, yycolumn);
                        }
                    }

{hyphenated}        { 
                        if (relevency == 0) { 
                            return new Token(Token.HYPHENATED, yytext(), yyline, yycolumn);
                        }
                    }

{delimeters}*       { }  