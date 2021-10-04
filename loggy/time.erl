-module(time).
-export([zero/0, inc/2, merge/2, leq/2, clock/1, update/3, safe/2]).


zero() ->
    0.

inc(Name, T) ->
    T+1.

merge(Ti,  Tj) ->
    if Ti > Tj -> Ti;
    true -> Tj end.

leq(Ti,Tj) ->
    Ti =< Tj.


clock(Nodes)->
    [{N, zero()} || N <- Nodes].

update(Node,  Time,  Clock)->
    lists:keyreplace(Node, 1, Clock, {Node, Time}).

safe(Time, Clock) ->
    lists:all(fun({_,T})-> leq(Time,T) end, Clock).


