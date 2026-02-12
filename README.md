# dotfile

My [better-vim](https://github.com/topazape/better-vim) configuration.

## Features

- **Theme**: tokyonight
- **Leader key**: `<Space>`
- **Claude Code integration** via [claudecode.nvim](https://github.com/coder/claudecode.nvim)
- Word wrap for prose filetypes (markdown, tex, groff), no wrap for code
- Auto-strip trailing whitespace on save
- Compiler keybind (`<leader>c`) with terminal output
- Auto-reload dwmblocks on config change
- Filetype detection for groff, calcurse notes, Xresources

## Key Bindings

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>c` | n | Compile current file |
| `<leader>p` | n | Open output |
| `<leader>w` | n | Toggle wrap |
| `<leader>b` | n | Open bibliography |
| `<leader>r` | n | Open references |
| `S` | n | Search & replace |
| `<leader>ac` | n | Toggle Claude Code |
| `<leader>af` | n | Focus Claude |
| `<leader>as` | v | Send selection to Claude |
| `<leader>ah` | n | Claude to bottom split |
| `<leader>av` | n | Claude to right split |