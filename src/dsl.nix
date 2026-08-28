let
  KDL_TAG = "__KDL_KIND";

  kinds = {
    raw = "kdl-raw";
    keyword = "kdl-keyword";
  };

  box = tag: data: {
    ${KDL_TAG} = tag;
    data = data;
  };

  is-special = tag: data: (data.${KDL_TAG} or null) == tag;

  start =
    {
      name,
      type ? null,
      arguments ? [ ],
      parameters ? { },
      body ? null,
    }:
    {
      inherit
        name
        type
        arguments
        parameters
        body
        ;

      __functor =
        self: x:
        if x ? ${KDL_TAG} then
          (self // { arguments = self.arguments ++ [ x ]; })
        else if builtins.typeOf x == "set" then
          (self // { parameters = self.parameters // x; })
        else if builtins.typeOf x == "list" then
          (self // { body = x; })
        else
          (self // { arguments = self.arguments ++ [ x ]; });
    };
in
{
  internal = {
    inherit is-special kinds;
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
