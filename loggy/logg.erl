-module(logg).
-export([start/1, stop/1]).

start(Nodes) ->
    spawn_link(fun() ->init(Nodes) end).

stop(Logger) ->
    Logger ! stop.

init(Nodes) ->
        Clock = vector:clock(Nodes),
        loop(Clock,[]).

loop(Clock, HoldBackQ) ->
    receive{log, From, Time, Msg} ->
        %io:fwrite(lists:flatten(io_lib:format("~p~n~n", [Time]))),
        UpdatedClock = vector:update(From, Time, Clock),
        UpdatedQueue = HoldBackQ++[{From, Time, Msg}],
        % go through q and print m that are now safe to print.
        {NotSafe,Safe} = splitQueue(UpdatedClock, UpdatedQueue, [],[]),
        lists:foreach(fun({From, T, Msg})->log(From,T,Msg)end,Safe),

        loop(UpdatedClock, NotSafe);
    stop ->
        lists:foreach(fun({From, Time, Msg}) -> log(From, Time, Msg) end, HoldBackQ),
        ok 
end.


splitQueue(_, [], NotSafe, Safe)->{NotSafe,Safe};
splitQueue(Cl, [{From, T, Msg}|Q], NotSafe,Safe)->
        case vector:safe(T, Cl) of
            true ->  splitQueue(Cl,Q, NotSafe, Safe++[{From, T, Msg}]);     
            false -> splitQueue(Cl, Q ,NotSafe++[{From, T, Msg}], Safe) 
        end.



log(From, Time, Msg) ->
    io:format("log: ~w ~w ~p~n", [Time, From, Msg]).
