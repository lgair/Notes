# Naming Conventions.
 1. Use snake case for all names (variable, function, class) in code
    created.
 2. Use camel case for all enum names (but snake case for names of enum types).
 3. The name of the header file should be the same as the name of the class it defines.
      Why: better organized code. If the header declares more than one function you are out of luck.
 4. First letter should be lower case for variable names and function names. First letter should be capitalized for class names and namespace names.
 5. Start comments with an upper case letter and end with a full stop. 
    - Comments need to be minimal, code should be self documenting.

# Best Practices.
### High effort to align with the following software desing best practices, in order of precedence.
- SOLID.
- DRY.
- YAGNI.
- KISS.

A) Avoid violating the rule of 5.
B) Use C++ aliases instead of typedef.
C) `const` everything - if it can be made const it should be made const. 
    - Keep the scope of variables as small as possible.
D) Avoid default initializing variables whenever possible.
E) A header file should provide the definition of no more than one object (class).
F) A source file should provide the implementation of as few objects (functions) as is reasonable.
G) Avoid using macros and defines.
H) Build should print zero warnings (with all warnings enabled).
I)  Move functions that are not part of the interface into anonymous namespace.
J) Favor forward declaring objects over including headers.
K) Use exceptions for errors that prevent the operation from proceeding. Do not use exceptions for other types of errors (recoverable errors).

# Integer types.
- Use types from <cstdint> instead of int/short/long where appropriate (low level logic, other code that relies on a type having certain number of bits).

# Style and formatting.
### Strictly follow K & R formatting style.
- Use Spaces instead of tabs.
 - Tabs should be four spaces wide.

# Alignment.
### Use horizontal alignment on function parameters.

| Column 3 | Column 4   | Next column | Next column | Next column | Columns…   |
|----------|------------|-------------|-------------|-------------|------------|
| type     | qualifier1 | qualifier2  | pointer     | qualifier3  | …          |

- Do not add extra indent to code that is in a namespace.
- Place function/method return type in the same line as the function name. Place all descriptors (inline, constexpr, template, [[attribute]] …) that relate to the function each in a separate line.
### Other.
- **Aim for <= 120 characters per line.**
