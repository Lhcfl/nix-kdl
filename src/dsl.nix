let
  symbols = {
    stop = "__KDL_DSL_STOPMARK";
    kind = "__KDL_KIND";
  };

  kinds = {
    raw = "kdl-raw";
    keyword = "kdl-keyword";
  };

  stop =
    x:
    x {
      ${symbols.kind} = "stop-mark";
      ${symbols.stop} = true;
    };

  continue =
    initial: f: arg:
    if (builtins.typeOf arg == "set" && builtins.hasAttr symbols.stop arg) then
      initial
    else
      continue (f initial arg) f;

  box = tag: data: {
    ${symbols.kind} = tag;
    data = data;
  };

  start =
    {
      name,
      type ? null,
      arguments ? [ ],
      parameters ? { },
      body ? null,
    }:
    continue
      {
        inherit
          name
          type
          arguments
          parameters
          body
          ;
      }
      (
        data: x:
        if builtins.typeOf x == "set" then
          if (builtins.hasAttr symbols.kind x) then
            (data // { arguments = data.arguments ++ [ x ]; })
          else
            (data // { parameters = data.parameters // x; })
        else if builtins.typeOf x == "list" then
          (data // { body = x; })
        else
          (data // { arguments = data.arguments ++ [ x ]; })
      );
in
{
  internal = {
    inherit stop symbols kinds;
  };

  exports = {
    n = name: start { name = name; };
    typed = type: name: start { inherit type name; };

    raw = box kinds.raw;

    keywords = {
      inf = box kinds.keyword "inf";
      "-inf" = box kinds.keyword "-inf";
      nan = box kinds.keyword "nan";
      null = box kinds.keyword "null";
      true = box kinds.keyword "true";
      false = box kinds.keyword "false";
    };
  };
}
