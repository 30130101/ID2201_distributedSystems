-module(hello).
-import(string, [len/1, concat/2, chr/2, substr/3, str/2, to_lower/1, to_upper/1]).
-export([main/0]).

main() ->
    sum([1,2,3],0).

str_random() ->
    Str1 = "ff",
    Str2 = "fd",
    io:fwrite("String : ~p ~p\n", [Str1, Str2]).

tuple_stuff() ->
    My_Data = {42,175,6.25},
    My_Data,
    {A,B,C} = My_Data,
    C,
    {D,_,_} = My_Data,
    D,
    My_Data2 = {height,6.25},
    {height,Ht} = My_Data2,
    Ht.


list_stuff() ->
    L = [1,2,3],
    L2 =[4,5,6],
    L3 = L ++ L2,
    L3,
    L4 = [hd(L)|L2],
    L4.

sum([],Sum) -> Sum;
sum([H|T], Sum) ->
    io:fwrite("Sum: ~p\n", [Sum]),
    sum(T, H + Sum).