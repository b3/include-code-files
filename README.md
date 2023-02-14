Include code from source files in pandoc
========================================

Pandoc filter to include code from source files as code blocks.

The filter is largely inspired by
[pandoc-include-code](https://github.com/owickstrom/pandoc-include-code)
written by [Oskar WICKSTRÖM](https://github.com/owickstrom).

This repository exists thanks to the work of [Albert
KREWINKEL](https://github.com/tarleb/) among other things in
[pandoc/lua-filters](https://github.com/pandoc/lua-filters/issues/207).

If you are a Quarto user, please use the official extension from the Quarto team:
<https://github.com/quarto-ext/include-code-files>.

## Quick Start

Install the extension whether by simply downloading the
[include-code-files.lua](_extensions/include-code-files/include-code-files.lua)
file somewhere on your computer or by cloning this repository:

```bash
git clone https://github.com/b3/include-code-files.git
```

You can then use the extension in any pandoc file:

``````markdown
```{include="hello.c"}
```
``````

When rendering include the path to `include-code-files.lua`

```bash
pandoc -s --lua-filter=include-code-files.lua test/input.md --output test/output.html
```

For complete details see the [Lua filter for pandoc](#lua-filter-for-pandoc) section below.

## Installing

The filter can be used without special installation, just by passing
the `include-code-files.lua` file path to pandoc via
`--lua-filter`/`-L`.

User-global installation is possible by placing the filter within the
filters directory of pandoc's user data directory. This allows to use
the filter just by using the filename, without having to specify the
full file path.

## Using

The filter recognizes code blocks with the `include` attribute present. It
swaps the content of the code block with contents from a file.

### Including Files

The simplest way to use this filter is to include an entire file:

    ```{include="hello.c"}
    ```

You can still use other attributes, and classes, to control the code blocks:

    ```{.c include="hello.c" numberLines}
    ```

### Ranges

If you want to include a specific range of lines, use `startLine` and `endLine`:

    ```{include="hello.c" startLine=35 endLine=80}
    ```

`start-line` and `end-line` alternatives are also recognized.

### Dedent

Using the `dedent` attribute, you can have whitespaces removed on each line,
where possible (non-whitespace character will not be removed even if they occur
in the dedent area).

    ```{include="hello.c" dedent=4}
    ```

### Line Numbers

If you include the `numberLines` class in your code block, and use `include`,
the `startFrom` attribute will be added with respect to the included code's
location in the source file.

    ```{include="hello.c" startLine=35 endLine=80 .numberLines}
    ```

## Example

An HTML version of [input.md](test/input.md) can be produced as
[output.html](test/output.html) with this command:

    pandoc -s --lua-filter=include-code-files.lua test/input.md --output test/output.html
