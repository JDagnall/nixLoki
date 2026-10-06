## Feat

- A debugger setup, I don't necessarily use debuggers a lot, but I do want to have one.
- Add nixCats setting to turn of the mouse for laptops
- Move to BirdeeHub/nix-wrapper-modules which is the replacement for nixCats
- When moving to nix-wrapper-modules, the way plugins depending on eachother is done
  needs to be changed to actually make that happen, and dependent plugins not load if
  they are missing a dependency.
- Move away from lazy.nvim because I'm not using most of its features, probably to vim.
  pack once I've updated to nvim 0.12, or to BirdeeHub/lze
- update to nvim 0.12/13

## Fix

- Rust-analyzer only lints on file save
- Jumping to ends of blocks consistently is annoying I'm not sure what the best setup
  for that behaviour is
- Bracket closing behaviour is not great, and a bit complicated with the autopairs.nvim,
  I want to be able to easily add different closing characters for different filetypes,
  like '<>' for rust for example.
