-- Go: LazyVim's `lang.go` extra (imported in config/lazy.lua) does the rest;
-- this only fixes its golangci-lint linter.
--
-- nvim-lint's golangcilint definition works out its args once, when the module
-- is first required, by running `golangci-lint version` and `go env GOMOD`. If
-- either is not executable at that moment -- as on first start, when Mason is
-- still installing golangci-lint -- `args` is nil for the rest of the session:
-- golangci-lint prints its help on every save and the JSON parser fails with
-- "Expected value but found invalid token at character 1".
--
-- A function linter is resolved on every lint, so this re-requires the module
-- until it comes back with args, then keeps that one.

local golangcilint

return {
  "mfussenegger/nvim-lint",
  opts = {
    linters = {
      golangcilint = function()
        if not (golangcilint and golangcilint.args) then
          package.loaded["lint.linters.golangcilint"] = nil
          golangcilint = require("lint.linters.golangcilint")
        end
        return golangcilint
      end,
    },
  },
}
