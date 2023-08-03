require "./expression"
require "./declaration/*"
require "./control-flow/*"

alias Declaration = VariableDeclaration | FunctionDeclaration
alias Statement = Declaration | ExpressionStatement |
                  ConditionalStatement |
                  NotAgainStatement | AgainStatement
