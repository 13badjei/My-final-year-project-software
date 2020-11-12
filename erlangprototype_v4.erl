-module(erlangprototype_v4).
-export([cloud/1, start/0, stop/0, write/2, read/1, searchval/2]).

searchval(_,[]) -> 0;
searchval(Name, [{Name,Val}|_]) -> Val;
searchval(Name, [_|L]) -> searchval(Name,L).

cloud(LData) ->
    receive
        {write, Owner, NewUpload} ->
            cloud([{Owner,NewUpload}|LData]);
        {get, Name, From} -> 
            From ! {patient, searchval(Name,LData)},
            cloud(LData);
        stop -> ok
    end.

start() ->
    Server_PID = spawn(erlangprototype_v4, cloud, 
[[{florian,120},{ben,80}]]),
    register(server_process, Server_PID).

stop() ->
    server_process ! stop,
    unregister(server_process).

write(Name,String2) ->
    server_process ! {write, Name, String2}.

read(Name) ->
    server_process ! {get, Name, self()},
    receive
         {patient, Data} -> Data
    end.

