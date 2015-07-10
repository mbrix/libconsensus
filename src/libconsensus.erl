%% Copyright 2015 Matthew Branton. All Rights Reserved.
%% Use of this source code is governed by the MIT
%% license that can be found in the LICENSE file.
%%
%% @doc Erlang NIF bindings
%% <a href="https://github.com/libbitcoin/libbitcoin-consensus.git">libbitcoin-consensus</a> Consensus Library

-module(libconsensus).
-author("mbranton@emberfinancial.com").

-export([verify_script/4,
		 flags/1]).

-on_load(init/0).

-define(APPNAME, libconsensus).
-define(LIBNAME, libconsensus_nif).

%% API

flags(FlagList) when is_list(FlagList) -> flags(FlagList, 0);
flags(Flag) -> getflag(Flag).
flags([], Flag) -> Flag;
flags([F|T], Flag) -> flags(T, getflag(F) bor Flag).

getflag(verify_flags_p2sh) -> 1 bsl 0;
getflag(verify_flags_strictenc) -> 1 bsl 1;
getflag(verify_flags_dersig) -> 1 bsl 2;
getflag(verify_flags_low_s) -> 1 bsl 3;
getflag(verify_flags_nulldummy) -> 1 bsl 4;
getflag(verify_flags_sigpushonly) -> 1 bsl 5;
getflag(verify_flags_minimaldata) -> 1 bsl 6;
getflag(verify_flags_discourage_upgradeable_nops) -> 1 bsl 7;
getflag(verify_flags_cleanstack) -> 1 bsl 8.

verify_script(_TransactionBin, _PrevScript, _TxInputIndex, _Flags) ->
	not_loaded(?LINE).

%% Iternal functions

init() ->
    SoName = case code:priv_dir(?APPNAME) of
        {error, bad_name} ->
            case filelib:is_dir(filename:join(["..", priv])) of
                true ->
                    filename:join(["..", priv, ?LIBNAME]);
                _ ->
                    filename:join([priv, ?LIBNAME])
            end;
        Dir ->
            filename:join(Dir, ?LIBNAME)
    end,
    erlang:load_nif(SoName, 0).

% This is just a simple place holder. It mostly shouldn't ever be called
% unless there was an unexpected error loading the NIF shared library.

not_loaded(Line) ->
    exit({not_loaded, [{module, ?MODULE}, {line, Line}]}).
