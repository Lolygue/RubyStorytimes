# Storytimes

# Get Started
Make sure you have a ruby compiler in order to run *main.rb*

The stories you create will need to be kept in a folder named *stories* in the same directory as *main.rb*.
In said folder, you can add a file with any name or extension you want.

## Syntax
Each story is programmed using specific commands specified by a character at the start of each line.

### "/" Character: Comments
Used for creating comments in your story. These provide no instructions to the story so it does not affect it in any
way. <br>
*Example:* <br>
`/This is a comment`

### ">" Character: Output
Used for outputting text into the console. <br>
*Example:* <br>
`>This will output text`

### "<" Character: Input
Used for getting input and storing it into a variable <br>
*Example:* <br>
`<variable`

### "@" Character: Label
Used for setting a place within the programming that can be returned to later.
*Example:* <br>
`@sceneLabel`

### "^" Character: Goto
Used for returning to a previously defined label.
*Example:* <br>
`^sceneLabel`

### "?" Character: Conditional
Used for checking if a condition is true. This command in particular uses 3 parameters:
1. Name of a variable
2. One of the following comparisons:
* `=` : True if left equals right
* `!` : True if left does not equal right
* `>` : True if left is greater than right
* `<` : True if left is less than right
* `>=` : True if left is greater than or equal to right
* `<=` : True if left is less than or equal to right
3. Name of a variable or a literal
If the condition was evaluated as false then the next line is skipped. <br>
*Example:*<br>
```
?var = 2
>var is equal to 2.
```

### "!" Character: Else
If one of the earlier conditionals was run, this conditional will skip the next line. <br>
```
?var = 2
>var is equal to 2.
!
>var does not equal 2.
```
If you won't be using an Else in your conditionals, append the `_noelse` command to the end of the conditionals<br>
*Example:* <br>
```
?var = 2
>var is equal to 2.
_noelse
```

## "{" and "}" Characters: Block
Groups multiple lines together into a single block. These allow conditionals to skip these entire blocks of code.<br>
*Example:*<br>
```
?var = 5
{
  >Guess what?
  >Var is equal to 5!
}
_noelse
```

## "$" Character: Variable Manager
Used for managing variables using 2 parameters:
1. Variable name
2. A formula with the specified syntax:
* Set of lone characters : Variable
* Any number : Integer
* Set of characters that start and end in quotes : String
* `+` : Adds right to left
* `-` : Subtracts left by right
* `*` : Multiplies left by right
* `/` : Divides left by right
* `%` : Remainder of left divided by right
* `^` : Left to the power of right
*Examples:*<br>
```
$integer 2
$string "hello world"
$integer integer+2
$string "hello world"+", how are you?"
$integer 10+5*2/3
```

## Output Substitution
Variables can be used to substitute what appears in output around `${}`.
*Example:*<br>
`>Money: $${money}`
There are also special variables that are specified by a `#` before the name of the variable:
* `#unix` : Returns unix timestamp
* `#year` : Returns current year
* `#month` : Returns current month
* `#day` : Returns current day
* `#hour` : Returns current hour
* `#version` : Returns version of RubyStorytimes
* `#random` : Returns random number between 0 and 65536

## "_" Character: Special Functions
Used for executing special functions within the story. A list of these functions includes:
* `_echo` : Output all running lines to console with line numbers.
* `_cls` : Clears the console.
* `_pause` : Waits for any key to be pressed.
* `_end` : Ends story.
* `_randomnew` : Generates a new seed for the `#random` special variable.
