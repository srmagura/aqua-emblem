window._util = {}

_util.getFunctionName = (fun) ->
    s = fun.toString();
    s = s.substr('function '.length);
    s = s.substr(0, s.indexOf('('));
    return s;
