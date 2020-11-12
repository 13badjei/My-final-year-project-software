-module(erlangprototypetest).

-export([start/0, client/1]).


start() ->

     erlangprototype:start(),
   
     mutex:start(),
	
     register(tester_process, self()),
	
     loop("file1", "file2", 10),
	
     unregister(tester_process),
	
     mutex:stop(),
	
     erlangprototype:stop().


loop(_, _, 0) ->
 true;


loop(FirstString, SecondString, N) ->
 erlangprototype:write(""),
	
spawn(erlangprototypetest, client, [FirstString]),
	
spawn(dropboxtest, client, [SecondString]),
   
receive
	
    done -> true
     
end,
     
receive
	
   done -> true
     
end,
	
	
io:format("Expected data = ~ts, actual data = ~ts~n~n",
       
[(FirstString ++ SecondString), erlangprototype:read()]),
	
loop(FirstString, SecondString, N-1).

client(Str) ->
     erlangprototype:upload(Str),
	
tester_process ! done.
	
