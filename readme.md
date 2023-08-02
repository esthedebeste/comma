# ,lang

pronounced "comma-lang" (or _[short pause]_ lang)

compiles down to c++ lmaoo

## syntax

no comments. to use comments, use the `,md` variant.

### variables

constants dont exist. sorry :p

```,
a sign = 1.
a,= 2.
```

### functions

the last declared variable gets returned. no variables being declared results in undefined behavior.

```,
yeah, a sign, b sign to sign.
    added sign = a + b.
haey.

double, a sign to sign.
    doubled sign = a * 2.
elbuod.

double yeah 1, 2.
```

### control flow

```,
chat if a > 1.
    a,= double a.
tahc.

basically as long as a < 10.
    a,= double a.
yllacisab.
```

for loops are fake and don't exist im afraid

### string literals

```,
some texttt = "hello chat\n".
putsnoln some.
```

### number literals

due to syntax and natural language ambiguity (some languages use commas before decimals, some use points) floating-point literals use spaces.

```,
oneinavariable sign = one.
oneandahalf math small = 1 5.
```

There are convenience _english_ sign-literals for 0 (`zero`), 1 (`one`), 2 (`two`), 3 (`three`), 4 (`four`), 5 (`five`), 6 (`six`), 7 (`seven`), 9 (`nine`), 10 (`ten`), and 100 (`hundred`).

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
  two times temporary_variable
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

a `,md` file will only have sections delimited by <code>\`\`\`,</code> and <code>\`\`\`</code> interpreted as code. this readme is a fully valid `,md` file, fyi.

## filenames

`hello.,`, `hello,` and `hello,,,,,,,,` are legal filenames.

the canonical way to use `,md` is for example `hello,md`. `hello.,md`, `hello.,.md`, and `hello.md` are also permitted by the ,lang compiler.

`/,$|md$/`
