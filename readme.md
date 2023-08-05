# ,

pronounced "comma" (or _[short pause]_)

compiles down to c++ lmaoo (AKA the compiler has a dependency on `clang++` existing and working)

## syntax

no comments. to use comments, use the [`,md` variant](#md).
don't forget to end your statements with `.` or `!`

### variables

constants dont exist. sorry :p

```,
a sign = 1.
a,= 2.
```

### functions

the last declared variable gets returned.  
no variables being declared results in undefined behavior.

```,
yeah a sign, b sign to sign.
  added sign = a plus b.
haey.

doubled a sign to sign.
  doubled sign = a times 2.
delbuod.
```

#### function calls

function calls are implicit and postfix.

```,
1, 2 yeah doubled.
```

### control flow

Control flow is labeled, and ends with the label backwards.

```,
aboveone a > 1?
  a,= a doubled.
:a < 1?
  a,= a plus 1.
:
  a,= a minus 1.
enoevoba.

basically a < 10?
  a,= a doubled.
  again!
yllacisab.

a, '\n' putsnoln.
```

for loops are fake and don't exist im afraid

### string literals

```,
some texttt = "hello chat
".
some putsnoln.
```

### number literals

due to syntax and natural language ambiguity (some languages use commas before decimals, some use points) floating-point literals use spaces.

```,
oneinavariable sign = one.
oneandahalf math small = 1 5.
```

There are convenience _english_ sign-literals for 0 (`zero`), 1 (`one`), 2 (`two`), 3 (`three`), 4 (`four`), 5 (`five`), 6 (`six`), 7 (`seven`), 9 (`nine`), 10 (`ten`), and 100 (`a hundred`).

### chance literals

instead of using `true` and `false`, you can use `true`, `maybe`, `false`, `always`, `sometimes`, and `never`.

```,
onceinawhile always divided by 3?
  "yippee!!" putswithaln.
elihwaniecno.
```

### operators

lets do a c++ to , mapping.

- `1 + 2` -> `one plus two`
- `1 - 2` -> `one minus two`
- `abs(1 - 5)` -> `five diff one`
- `4 / 2` -> `four divided by two`
- `4 * 2` -> `four times two`
- `pow(2, 5)` -> `two to the power of five`
- `4 % 2` -> `four modulo two`
- `2 * 5 + 1` -> `two times five plus one`
- `2 * (5 + 1)` ->
  ```,
  temporary_variable sign = five plus one.
  two times temporary_variable putswithaln.
  ```

### types

LOL right. okay so basically to map some , types to c++ types:

- `sign` -> `ssize_t`
- `unsi` -> `size_t`
  - `sign six-four` -> `int64_t`
  - `unsi six-four` -> `uint64_t`
  - `sign three-two` -> `int32_t`
  - `unsi three-two` -> `uint32_t`
- `math small` -> `float`
- `math big` -> `double`
- `chacha` -> `char`
- `texttt` -> `std::string`

## ,md

a `,md` file will only have sections delimited by <code>\`\`\`,</code> and <code>\`\`\`</code> interpreted as code. this readme is a fully valid `,md` file, for example. you can run it with

```sh
# make sure you have crystal installed by the way :p
shards build comma
./bin/comma ./readme.md -o ./bin/readme
./bin/readme
```

## filenames

`hello.,`, `hello,` and `hello,,,,,,,,` are legal filenames.

the canonical way to use `,md` is for example `hello,md`. `hello.,md`, `hello.,.md`, and `hello.md` are also permitted by the ,lang compiler.
