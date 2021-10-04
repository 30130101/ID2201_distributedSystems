-module(map).
-export([new/0, update/3, reachable/2, all_nodes/1]).

%keyfind/3, keydelete/2, map/2, foldl/3

new()->
    [].
    
update(Node,Links,Map)->
    [{Node,Links}|lists:keydelete(Node,1,Map)].
        

reachable(Node,Map)->
    case lists:keyfind(Node, 1, Map) of
        {_,V} ->
             V;
        false ->
            []
    end.


all_nodes(Map) ->
    lists:foldl(fun({K,V}, L)-> lst_mem([K|L],V) end, [], Map).


lst_mem(L,[]) -> L;
lst_mem(L,[H|T]) ->
    case  lists:member(H,L) of
        true -> lst_mem(L,T);
        false -> lst_mem([H|L],T)
    end.
