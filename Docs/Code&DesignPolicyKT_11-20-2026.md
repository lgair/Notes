# 

# 

# 

# 

# 

# Code and Design Policy

[1\. Codebase Structure	3](#1.-codebase-structure)

[Control project	3](#control-project)

[1\. Layout	3](#1.-layout)

[2\. PL and Sensor modules	4](#2.-pl-and-sensor-modules)

[3\. Dependencies between modules	4](#3.-dependencies-between-modules)

[4\. control and video modules	4](#4.-control-and-video-modules)

[5\. Utilities	4](#5.-utilities)

[2\. Best Practices	5](#2.-best-practices)

[Integer types	5](#integer-types)

[Magic numbers	6](#magic-numbers)

[Established Convention	6](#established-convention)

[3\. Naming conventions	7](#3.-naming-conventions)

[4\. Comments	8](#4.-comments)

[5\. Formatting Style	9](#5.-formatting-style)

[Indentation style	9](#indentation-style)

[Alignment	10](#alignment)

[Other	11](#other)

[6\. Project specific	12](#6.-project-specific)

[Control project	12](#control-project-1)

# 1\. Codebase Structure {#1.-codebase-structure}

## Control project {#control-project}

### 1\. Layout {#1.-layout}

The control project has the following root directory structure:

| Directory | Description |
| :---- | :---- |
| cmake | Source files for build functions. |
| external | Shared and 3rd party libraries. |
| src | Source code. |
| test | Test code \- control\_test target. |
| utils | Utilities used in the build process. |

The src directory has the following directory structure:

| Directory | Description |
| :---- | :---- |
| Calibration | Code related to loading an applying calibration data. |
| Communication | Code related to communication with clients (both REST and DBus).**TODO** |
| Control | The control module. |
| FMM | Code related to managing the FMM. |
| PL | Code related to managing the FPGA. |
| Sensors | Code related to managing the sensor. |
| Utils | Utilities.Organized further into:\- common \- utilities that are not specific to this project\- Kron \- utilities that are specific to this project\- gct2setting \- utilities that are used for converting between                            gct and setting objects\- Enums \- enums |
| Video | The video module. |

### 2\. PL and Sensor modules {#2.-pl-and-sensor-modules}

These two modules should not contain any high-level logic. They should only translate high-level requests into register writes/reads.

The goal is to have the control service be reused in many Krontech products and so the implementation of the Sensor/FPGA modules will change depending on the product specified in the cmake variable. This implementation is abstracted by using the headers in root of src/PL and src/Sensors directories.

### 3\. Dependencies between modules {#3.-dependencies-between-modules}

While the PL and Sensor modules can make calls to any function from the Control and Video modules (and make use of any object from Control and Video modules) the Control and Video modules should only access the PL and Sensor modules via the exposed API.

### 4\. control and video modules {#4.-control-and-video-modules}

Deciding whether a piece of code should be placed in the Control or Video modules depends on whether that functionality is related to video pipeline or not.

### 5\. Utilities {#5.-utilities}

Utilities can be organized into two groups: general and Kron specific. General utilities do not have includes outside of (possibly) Utils directory. Kron specific utilities might include enums and functions from Control or Video.

# 

# 2\. Best Practices {#2.-best-practices}

1\. Maximum effort should be made to follow:

- SOLID  
- DRY  
- YAGNI  
- KISS

2\. Avoid violating the rule of 5\.

3\. Use C++ aliases instead of typedef.

4\. const everything \- if it can be made const it should be made const. Keep the scope of variables as small as possible.  
*Why: it makes reading code easier \- it reduces the mental workload when reading code.*

5\. Avoid default initializing variables whenever possible.  
*Why: work will be done (instruction executed) for no reason.*

6\. A header file should provide the definition of no more than one object (class).  
*Why: compile time reduction, better organized code.*

7\. A source file should provide the implementation of as few objects (functions) as is reasonable.  
*Why: compile time reduction.*

8\. Avoid using macros and defines.

9\. Build should print zero warnings (with all warnings enabled).

10\. Move functions that are not part of the interface into anonymous namespace.  
*Why: it makes reading code easier. Also, faster linking.*

11\. Favor forward declaring objects over including headers.  
*Why: compile time reduction.*

12\. Use exceptions for errors that prevent the operation from proceeding. Do not use exceptions for other types of errors (recoverable errors).

## Integer types {#integer-types}

13\. Use types from \<cstdint\> instead of int/short/long where appropriate (low level logic, other code that relies on a type having certain number of bits).

14\. Take extra caution when mixing integer types of different signs.

## Magic numbers {#magic-numbers}

15\. The four rules of adding magic numbers to the code:

| Repetition | Don’t repeat the same magic number in multiple places. *Why: violates DRY.* |
| :---- | :---- |
| **Annotation** | Consider whether the COMPILE\_TIME\_CONFIGURATION\_CONSTANT should be used to annotate the magic number. |
| **Calculation** | Can a consteval function be used to showcase the thinking behind the constant (as opposed to doing the calculations on paper and then just writing the result). |
| **Documentation** | Reference the document (page) where the number is coming from, provide a link to a web resource, explain the equations or thinking process that produced the number.Explain under what circumstances should the number be updated (changed). |

## Established Convention {#established-convention}

16\. If there is an established convention in regards to how to do something, follow the same convention \- this includes formatting, naming and everything else.  
*Why: it makes reading code easier.*

# 

# 3\. Naming conventions {#3.-naming-conventions}

1\. Use snake case for all names (variable, function, class) in the codebase.  
2\. Use camel case for all names in the control service API.  
3\. Use camel case for all enum names (but snake case for names of enum types).

4\. The name of the header file should be the same as the name of the class it defines.  
*Why: better organized code. If the header declares more than one function you are out of luck.*

5\. First letter should be lower case for variable names and function names. First letter should be capitalized for class names and namespace names.

6\. First letter should be upper case for elements of the Settings enum.

7\. Start comments with an upper case letter and end with a full stop.

# 

# 4\. Comments {#4.-comments}

1\. Do not write doxygen comments.

2\. Write code comments only when they add information that cannot be expressed through code.

# 

# 5\. Formatting Style {#5.-formatting-style}

## Indentation style {#indentation-style}

1\. Use spaces, not tabs.  
2\. Use 4 spaces per tab.  
3\. Use K\&R formatting.

4\. Example if block:

	

Not good:

| if( configuration.is\_good() and some\_other\_condition()    and number\_of\_iterations \< 1000 and the\_last\_condition()    and just\_kidding\_there\_are\_more\_conditions() ) {    do\_some\_processing();    auto var \= get\_value();    crash\_the\_camera();} *Why: takes a bit of effort to figure out where condition ends and body begins.* |
| :---- |

Good:

| if( configuration.is\_good() and some\_other\_condition()and number\_of\_iterations \< 1000 and the\_last\_condition()and just\_kidding\_there\_are\_more\_conditions() ) {    do\_some\_processing();    auto var \= get\_value();    crash\_the\_camera();} *Why: immediately clear where body begins.* |
| :---- |

## Alignment {#alignment}

5\. Use horizontal alignment on function parameters:

| Column 3 | Column 4 | Next column | Next column | Next column | Columns… |
| :---- | :---- | :---- | :---- | :---- | :---- |
| type | qualifier1 | qualifier2 | pointer | qualifier3 | … |

*Why: it makes reading code easier. Statistically SW developers spend more time (80% of time) reading code than writing code. It therefore makes sense to optimize code for reading. Horizontal alignment makes reading much easier.*

6\. Do not add extra indent to code that is in a namespace.  
*Why: it does not add any information to the code. It does not make code easier to read. But it does reduce available line width.*

7\. Place function/method return type in the same line as the function name. Place all descriptors (inline, constexpr, template, \[\[attribute\]\] …) that relate to the function each in a separate line.

## Other {#other}

8\. Aim for \<= 120 characters per line.

9\. Use \#pragma once instead of include guards.  
*Why: it is easier than having to come up with a name. Also, you will rename the file and forgot to rename the macro. I have seen it happen too many times.*

10\. A class should have the following structure (top to bottom):

- types  
- members  
- special methods  
- all other methods

# 

# 6\. Project specific {#6.-project-specific}

## Control project {#control-project-1}

1\. All notify events for the same event type must have the same format. This is to reduce parsing complexity on the client.

2\. Format for error messages:

* End every message with full stop (unless the end is a string which already has a full stop) and without a trailing space.  
* Don't yell at the user \- don't end the message with an exclamation point or use ALL UPPER CASE LETTERS.  
* Start every message with an upper case letter.  
* Don't use informal language.  
* Only error messages should be tagged with the MSG2USR tag.

3\. Keep this document updated when extanding/updating the API: [API Interaction Matrix 2](https://docs.google.com/spreadsheets/d/1hhJNjj-qj0x6I6pYO41HE5XTD-YMAG3vj-_hziOo0j4/edit?usp=drive_link).

