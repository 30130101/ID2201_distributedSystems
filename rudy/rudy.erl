-module(rudy).
-export([start/1, stop/0]).
%“http://localhost:8080/foo”

start(Port) ->
    register(rudy, spawn(fun() -> init(Port) end)).
stop() ->
    exit(whereis(rudy), "time to die").

init(Port) ->
    Opt = [list, {active, false}, 
        {reuseaddr, true}],
        case gen_tcp:listen(Port, Opt) of 
            {ok, Listen} ->
                handler(Listen), % :
                gen_tcp : close(Listen),
                ok;
            {error, Error} ->
                error
            end.

handler(Listen) ->
    case gen_tcp:accept(Listen) of
        {ok, Client} ->
            request(Client), % : %handling requests sequencially
            %spawn_link(fun() -> request(Client) end), %for concurrency
			handler(Listen); 
        {error, Error} ->
            error
        end.

request(Client) ->
    Recv = gen_tcp:recv(Client, 0),
    case Recv of
        {ok, Str} ->
            Request = http:parse_request(Str), % :
            Response = reply(Request),
            gen_tcp:send(Client, Response);
        {error, Error} ->
            io:format("rudy: error: ~w~n", [Error])
    end,
    gen_tcp:close(Client).

reply({{get, URI, _}, _, _}) ->
    timer:sleep(40), %simulate file handling
    http:ok(retrieve_html(URI)).

retrieve_html(URI) ->
	"<html>
    <body>
    <h1>Rudy</h1>
    <p>"++URI++"</p>
    </body>
    </html>".