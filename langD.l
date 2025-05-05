%{
#include <stdio.h>
%}

KEYWORD     if|for|while|do|exit|else|case|switch|until
ID          [a-zA-Z][a-zA-Z0-9]*
FLOAT       ([0-9]+\.[0-9]+|\.[0-9]+)
INTEGER     [0-9]+
COMMENT     \*\*\*.*      // Single-line comment
STRING      \'[^\']*\'    // String constants in single quotes
WS          [ \t]+        // Whitespace
PUNCT       [\[\]\{\}\(\),]
REL_OP      (:=|<>|==|!=|<=|>=|<|>)
MATH_OP     [\+\-\*\%]

%%
{KEYWORD}   { printf("Keyword: %s\n", yytext); }
{ID}        { printf("Identifier: %s\n", yytext); }
{FLOAT}     { printf("Float: %s\n", yytext); }
{INTEGER}   { printf("Integer: %s\n", yytext); }
{COMMENT}   { printf("Comment: %s\n", yytext); }
{STRING}    { printf("String constant: %s\n", yytext); }
{REL_OP}    { printf("Relational operator: %s\n", yytext); }
{MATH_OP}   { printf("Math operator: %s\n", yytext); }
{PUNCT}     { printf("Punctuation: %s\n", yytext); }
{WS}        { /* Ignore whitespace */ }
.           { printf("Unknown character: %s\n", yytext); }
%%

int main() {
    yylex();
    return 0;
}





#include <stdio.h>
#include <string.h>
#include <ctype.h>

int isKeyword(const char *str) {
    const char *keywords[] = {
        "if", "for", "while", "do", "exit", "else", "case", "switch", "until"
    };
    for (int i = 0; i < 9; i++) {
        if (strcmp(str, keywords[i]) == 0)
            return 1;
    }
    return 0;
}

int main() {
    char ch, buffer[100];
    int i = 0;

    printf("Enter the code (Ctrl+D to end):\n");

    while ((ch = getchar()) != EOF) {
        // Skip whitespace
        if (ch == ' ' || ch == '\t')
            continue;

        // Identifier or keyword
        if (isalpha(ch)) {
            i = 0;
            buffer[i++] = ch;
            while (isalnum(ch = getchar())) {
                buffer[i++] = ch;
            }
            buffer[i] = '\0';
            ungetc(ch, stdin);
            if (isKeyword(buffer))
                printf("Keyword: %s\n", buffer);
            else
                printf("Identifier: %s\n", buffer);
        }

        // Number or Float
        else if (isdigit(ch)) {
            i = 0;
            buffer[i++] = ch;
            int isFloat = 0;
            while ((ch = getchar()) != EOF && (isdigit(ch) || ch == '.')) {
                if (ch == '.') isFloat = 1;
                buffer[i++] = ch;
            }
            buffer[i] = '\0';
            ungetc(ch, stdin);
            if (isFloat)
                printf("Float: %s\n", buffer);
            else
                printf("Integer: %s\n", buffer);
        }

        // Float starting with '.'
        else if (ch == '.') {
            ch = getchar();
            if (isdigit(ch)) {
                i = 0;
                buffer[i++] = '.';
                buffer[i++] = ch;
                while (isdigit(ch = getchar()))
                    buffer[i++] = ch;
                buffer[i] = '\0';
                ungetc(ch, stdin);
                printf("Float: %s\n", buffer);
            } else {
                printf("Unknown token: .\n");
                ungetc(ch, stdin);
            }
        }

        // String constant
        else if (ch == '\'') {
            i = 0;
            while ((ch = getchar()) != '\'' && ch != EOF) {
                buffer[i++] = ch;
            }
            buffer[i] = '\0';
            if (ch == '\'')
                printf("String: %s\n", buffer);
            else
                printf("Unterminated string!\n");
        }

        // Single-line comment ***
        else if (ch == '*') {
            char c1 = getchar(), c2 = getchar();
            if (c1 == '*' && c2 == '*') {
                printf("Comment: ");
                while ((ch = getchar()) != '\n' && ch != EOF) {
                    putchar(ch);
                }
                printf("\n");
            } else {
                printf("Operator: *\n");
                ungetc(c2, stdin);
                ungetc(c1, stdin);
            }
        }

        // Punctuation
        else if (ch == '[' || ch == ']' || ch == '{' || ch == '}' || ch == '(' || ch == ')' || ch == ',') {
            printf("Punctuation: %c\n", ch);
        }

        // Operators
        else if (ch == ':' || ch == '=' || ch == '<' || ch == '>' || ch == '!') {
            char next = getchar();
            char op[3] = {ch, next, '\0'};
            if ((ch == ':' && next == '=') || 
                (ch == '<' && next == '>') ||
                (ch == '=' && next == '=') ||
                (ch == '!' && next == '=') ||
                (ch == '<' && next == '=') ||
                (ch == '>' && next == '=')) {
                printf("Relational operator: %s\n", op);
            } else {
                ungetc(next, stdin);
                printf("Operator: %c\n", ch);
            }
        }

        // Math Operators
        else if (ch == '+' || ch == '-' || ch == '*' || ch == '%') {
            printf("Math operator: %c\n", ch);
        }

        // Unknown character
        else {
            printf("Unknown symbol: %c\n", ch);
        }
    }

    return 0;
}
