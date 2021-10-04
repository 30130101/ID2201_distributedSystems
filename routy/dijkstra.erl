-module(dijkstra).
-export([table/2, route/2]).

entry(Node, Sorted)->
    case lists:keyfind(Node, 1, Sorted) of
        {_,X,_} -> X;
        false -> 0
    end.

replace(Node, N, Gateway, Sorted)->
    L=lists:keyreplace(Node,1,Sorted,{Node,N,Gateway}),
    lists:keysort(2,L).

update(Node, N, Gateway, Sorted)->
    X = entry(Node, Sorted),
    if 
        X > N -> replace(Node,N,Gateway,Sorted);
        true -> Sorted
    end.

%case 1
iterate([], Map, Table) -> Table;
%case 2
iterate([{_,inf,_}|_], Map, Table) -> Table;
%case 3
iterate([{X,_,Y}|T], Map, Table) ->
    R = map:reachable(X,Map),
    Sorted = lists:foldl(fun(N,T) -> update(N, 1, X, T) end, T, R),
    iterate(Sorted, Map,[{X,Y}|Table]).
         
 table(Gateways, Map) ->
    All_nodes = map:all_nodes(Map),
    Unsorted = lists:foldl(fun(Entry,L)-> 
            case lists:member(Entry,Gateways) of
                true -> [{Entry,0,Entry}|L];
                false -> [{Entry,inf,unknown}|L]
            end
         end,[], All_nodes),
    Sorted = lists:keysort(2,Unsorted),
    iterate(Sorted, Map, []).

route(Node, Table) ->
    case lists:keyfind(Node, 1, Table) of
        {_,G} -> {ok, G};
        false -> notfound
    end.