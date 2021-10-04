-module(test0).
-export([run/2]).


run(Sleep, Jitter) ->
    Log = logg:start([john, paul, ringo, george]),
    A = worker:start(john, Log, 13, Sleep, Jitter),
    B = worker:start(paul, Log, 23, Sleep, Jitter),
    worker:peers(A, [B]),
    worker:peers(B, [A]),
    timer:sleep(5000),
    logg:stop(Log),
    worker:stop(A),
    worker:stop(B).