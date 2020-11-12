-module(erlangprototype_v2).
-export([cloud/1, start/0, stop/0, write/1, read/0, upload/1]).

cloud(LData) ->
    receive
        {write, Owner, NewUpload} ->
            cloud({Owner,NewUpload});
        {get, Name, From} -> where {Name, _} = LData,
            
            From ! {patient, Data},
            cloud(Data);
        stop -> ok
    end.

start() ->
    Server_PID = spawn(erlangprototype, cloud, [""]),
    register(server_process, Server_PID).

stop() ->
    server_process ! stop,
    unregister(server_process).

write(String2) ->
    server_process ! {write, String2}.

read() ->
    server_process ! {get, self()},
    receive
%        {fileContents, String2} -> String2
         {patient, Data} -> Data
    end.

upload(Data) ->
%    mutex:wait(),
    OldFile = read(),
    NewFile = OldFile ++ Data,
    write(NewFile).
%    mutex:signal().
