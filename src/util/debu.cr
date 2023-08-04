ENABLE_DEBU = false

# alternative for `p` macro
macro debu!(*exps)
  {% if !ENABLE_DEBU %}
    # debu is disabled
  {% else %}
    {
      {% for exp, i in exps %}
        begin
          %name = "#{{{@def.name.stringify}}}".sub("parse_", "")
          %prefix = "#{ " " * Math.max(0, 21 - %name.size) }#{%name} - #{{{ exp.stringify }}} => "
          ::print %prefix
          ::p({{exp}})
        end,
      {% end %}
    }
  {% end %}
end
