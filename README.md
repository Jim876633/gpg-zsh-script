# GPG ZSH Script

This script provides functions to manage GPG keys and configure Git to use GPG for signing commits.

## Functions

### `echoC`

Prints text with a specified color.

#### Usage

```bash
echoC [-n] <color_code> <text>
```

- `-n`: Optional flag to omit the newline at the end.
- `<color_code>`: The color code for the text.
- `<text>`: The text to print.

### `gpgf`

Sets the global Git configuration for GPG commit signing.

#### Usage

```bash
gpgf
```

Prompts the user to set or unset the global `commit.gpgsign` flag.

### `gpgs`

Lists available GPG keys and allows the user to set a signing key or delete a key.

#### Usage

```bash
gpgs
```

Prompts the user to select a GPG key and choose an action (set as signing key locally, or delete the key).

## Example

To use these functions, source the `.zshrc` file in your terminal:

```bash
source /path/to/.zshrc
```

Then you can call the functions directly:

```bash
gpgf
gpgs
```
