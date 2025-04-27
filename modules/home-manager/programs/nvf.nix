{
  pkgs,
  inputs,
  lib,
  config,
  host,
  ...
}: {
  options."nvf".enableModule = lib.mkOption {
    description = "Enable the nvf module";
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config."nvf".enableModule {
    programs.nvf = {
      enable = true;
      # your settings need to go into the settings attribute set
      # most settings are documented in the appendix
      settings = {
        vim.viAlias = true;
        vim.vimAlias = true;
        vim.lsp = {
          enable = true;
        };

        vim.statusline.lualine.enable = true;
        vim.telescope.enable = true;
        vim.autocomplete.nvim-cmp.enable = true;
        vim.filetree.nvimTree.enable = true;

        vim.options.tabstop = 2;
        vim.options.shiftwidth = 2;
        vim.options.expandtab = false;
        vim.options.autoindent = true;
        vim.options.smartindent = true;
        vim.options.cindent = true;

        vim.languages = {
          enableLSP = true;
          enableTreesitter = true;

          nix.enable = true;
          markdown.enable = true;
          ts.enable = true;
        };
      };
    };
  };
}
