{ pkgs, ... }:
{
  home.packages = with pkgs; [
    emacs
    nil
    (python3.toPythonApplication python3.pkgs.black)
    (python3.toPythonApplication python3.pkgs.isort)
  ];
}
