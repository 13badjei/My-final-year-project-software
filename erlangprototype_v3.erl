-module(erlangprototype_v3).
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
    Server_PID = spawn(erlangprototype_v3, cloud, [""]),
    register(server_process, Server_PID),
{Florian, blood_pressure} = 120,
{Ben, blood_pressure} = 80.

stop() ->
    server_process ! stop,
    unregister(server_process).

write(String2) ->
    server_process ! {write, String2}.

read() ->
    server_process ! {get, self()},
    receive
         {patient, Data} -> Data
    end.

upload(Data) ->
    OldFile = read(),
    NewFile = OldFile ++ Data,
    write(NewFile).

if
  blood_pressure == 120 ->
                  io:fwrite("This is Florian's blood pressure");
  true ->
if
   blood_pressure == 80 ->
                  io:fwrite("This is Ben's blood pressure");

