{
  "languageserver" = {
    "dhall" = {
      "command" = "dhall-lsp-server";
      "filetypes" = [ "dhall" ];
    };

    "elm" = {
      "command" = "elm-language-server";
      "filetypes" = [ "elm" ];
      "rootPatterns" = [ "elm.json" ];
    };


    "nix" = {
      "command" = "rnix-lsp";
      "filetypes" = [ "nix" ];
    };
  };

  "yank.highlight.duration" = 700;
}
