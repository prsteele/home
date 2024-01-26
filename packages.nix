{ pkgs, ... }:
{
  home.packages = with pkgs; [
    emacs
    nil
    (python3.pkgs.toPythonApplication python3.pkgs.black)
    (python3.pkgs.toPythonApplication python3.pkgs.isort)
  ];
}
