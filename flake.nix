{
  description = "A KDL generator";

  inputs = { };

  outputs = _: {
    kdl = import ./src/kdl.nix;
  };
}
