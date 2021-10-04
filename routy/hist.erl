-module(hist).
-export([new/1, update/3]).

new(Name)->
    [{inf, Name}].

update(Node, N, History)->
    case lists:keyfind(Node,2,History) of
        {C,_} -> case C < N of
            true -> {new, lists:keyreplace(Node,2,History,{N,Node})};
            false -> old
            end;
        false -> {new, [{N,Node}|History]}
    end.