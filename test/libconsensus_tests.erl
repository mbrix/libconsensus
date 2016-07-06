%% Copyright 2015 Matthew Branton. All Rights Reserved.
%% Use of this source code is governed by the MIT
%% license that can be found in the LICENSE file.
%%


-module(libconsensus_tests).
-author('mbranton@emberfinancial.com').

-include_lib("eunit/include/eunit.hrl").

start() ->
	ok.

stop(_) ->
	ok.

p2pkh() ->
   TxBin = hexstr_to_bin("01000000017d01943c40b7f3d8a00a2d62fa1d560bf739a2368c180615b0a7937c0e883e7c000000006b4830450221008f66d188c664a8088893ea4ddd9689024ea5593877753ecc1e9051ed58c15168022037109f0d06e6068b7447966f751de8474641ad2b15ec37f4a9d159b02af68174012103e208f5403383c77d5832a268c9f71480f6e7bfbdfa44904becacfad66163ea31ffffffff01c8af0000000000001976a91458b7a60f11a904feef35a639b6048de8dd4d9f1c88ac00000000"),
   Prevout = hexstr_to_bin("76a914c564c740c6900b93afc9f1bdaef0a9d466adf6ee88ac"),
   Index = 0,
   ?assertEqual(true, libconsensus:verify_script(TxBin, Prevout, Index,
   												 libconsensus:flags(verify_flags_p2sh))).

scripts1() ->
	%% Multiple input TX.
	TxBin = hexstr_to_bin("0100000002ade38cdf7f55909e5a16541fa9e238a438ea0dd9d8515155062ca99b4918120e000000008a473044022020bf8a36c8692ca2e4af3d24bb9d4fcd5f36a9758f32ad5766a926b7ad11fb9b02200a3832ae56a03adc9f782e253b252386727646a21e628b4561efc941257fed21014104ee125fce9778890e8cd618c046d26bb653dcb6a2984b724fa7ea0982d4d2218aca73debba5b2598006daf1a9660681e5630269bd0fa168ca2ea9d248b4076ce1ffffffffade38cdf7f55909e5a16541fa9e238a438ea0dd9d8515155062ca99b4918120e010000008b48304502210087c80a65b1777dc62abb4ec7793cd77969763482c2dfde7bc67a2719542d7d3d0220699ee2530cdca9261bfa0da42b2d1ec660dbe6d0223b54c32793408fc7c70418014104089fe312aebfe2c3c577d67ec3d70f24c05728df8d51e997a9eb95ce83000daca750d634241a3b14a92f7ef39bb75650d34a2835e754a163eb95d48875bf09b3ffffffff0240d2df03000000001976a9147cdc6cb328fb521ec134d17638ef4cb6548fce1488ac8056f83b040000001976a914d99ffaf3e014ed79d194bb80f3649f6ddc1e005988ac00000000"),
	Prevout = hexstr_to_bin("76a914c0fa599e8312940f21a942c4dfc1ffa61848a7c088ac"),
	Index = 0,
	?assertEqual(true, libconsensus:verify_script(TxBin, Prevout, Index,
												  libconsensus:flags(verify_flags_p2sh))).

scripts2() ->
	%% Include OP_CODESEPARATOR in SCRIPTSIG PUSH
	TxBin = hexstr_to_bin("01000000021e49254f65210580b6fe836d0bb35a54c9610bf33397156d8c5c89d5979bce7e000000008b483045022100a5db4669e63d2e7c7b0c6d7e0f2cb7667d5f227d533be0cc16d551e54a5550eb0220270ebd7e6f06e7c904afffc2f799e1ad1cff44710131f45d537a7ea46734a913014104809f37b97eeb04de7a1b71d9be14208d7de92ca7a4f72c2387a9b5d55f630ef2d4c75182586dee0ebe9558650a80ace55a69e097cce69d1e91d24c0f3579c90affffffff1e49254f65210580b6fe836d0bb35a54c9610bf33397156d8c5c89d5979bce7e0100000089463043021f01cce298b03dec09b57a25ac1015aec27192ef518ee9bd24592d5eafba40b302202c892c46d3c2828daaf07090c687600eea06ce3df4fd376e85185c7e2cbf33a30141045bb81524efd5c253fb6f19470ee37640f38444f16152b361ca2ea54791294f1613df9bb7a01fde2331de24d7547abc3ae7a4967d84f29ecb80b3ed31739d3494ffffffff02805f1148030000001976a914e5f4b77fa847a5bc7601d837a99d03ae907b88ad88ac00840449010000001976a9140569531928c7c70482eb79842f66ab622e40488b88ac00000000"),
	Prevout = hexstr_to_bin("76a914eed7a31a2decb9b67cab4822316a496380e89c0288ac"),
	Index = 1,
	?assertEqual(true, libconsensus:verify_script(TxBin, Prevout, Index,
												  libconsensus:flags(verify_flags_p2sh))).
scripts3() ->
	%% OP_CHECKMULTISIG + CODESEPARATOR
	TxBin = hexstr_to_bin("01000000024de8b0c4c2582db95fa6b3567a989b664484c7ad6672c85a3da413773e63fdb8000000006b48304502205b282fbc9b064f3bc823a23edcc0048cbb174754e7aa742e3c9f483ebe02911c022100e4b0b3a117d36cab5a67404dddbf43db7bea3c1530e0fe128ebc15621bd69a3b0121035aa98d5f77cd9a2d88710e6fc66212aff820026f0dad8f32d1f7ce87457dde50ffffffff4de8b0c4c2582db95fa6b3567a989b664484c7ad6672c85a3da413773e63fdb8010000006f004730440220276d6dad3defa37b5f81add3992d510d2f44a317fd85e04f93a1e2daea64660202200f862a0da684249322ceb8ed842fb8c859c0cb94c81e1c5308b4868157a428ee01ab51210232abdc893e7f0631364d7fd01cb33d24da45329a00357b3a7886211ab414d55a51aeffffffff02e0fd1c00000000001976a914380cb3c594de4e7e9b8e18db182987bebb5a4f7088acc0c62d000000000017142a9bc5447d664c1d0141392a842d23dba45c4f13b17500000000"),
	Prevout = hexstr_to_bin("142a9bc5447d664c1d0141392a842d23dba45c4f13b175"),
	Index = 1,
	?assertEqual(true, libconsensus:verify_script(TxBin, Prevout, Index,
												  libconsensus:flags(verify_flags_p2sh))).

%% Testnet Scripts

testnet1() ->
	TxBin = hexstr_to_bin("010000000560e0b5061b08a60911c9b2702cc0eba80adbe42f3ec9885c76930837db5380c001000000054f01e40164ffffffff0d2fe5749c96f15e37ceed29002c7f338df4f2781dd79f4d4eea7a08aa69b959000000000351519bffffffff0d2fe5749c96f15e37ceed29002c7f338df4f2781dd79f4d4eea7a08aa69b959020000000452018293ffffffff0d2fe5749c96f15e37ceed29002c7f338df4f2781dd79f4d4eea7a08aa69b95903000000045b5a5193ffffffff0d2fe5749c96f15e37ceed29002c7f338df4f2781dd79f4d4eea7a08aa69b95904000000045b5a5193ffffffff06002d310100000000029f91002d3101000000000401908f87002d31010000000001a0002d3101000000000705feffffff808730d39700000000001976a9140467f85e06a2ef0a479333b47258f4196fb94b2c88ac002d3101000000000604ffffff7f9c00000000"),
	Prevout = hexstr_to_bin("4f01e40164"),
	Index = 0,
	?assertEqual(true, libconsensus:verify_script(TxBin, Prevout, Index,
												  libconsensus:flags(verify_flags_p2sh))).

negative() ->
   TxBin = hexstr_to_bin("01000000017d01943c40b7f3d8a00a2d62fa1d560bf739a2368c180615b0a7937c0e883e7c000000006b4830450221008f66d188c664a8088893ea4ddd9689024ea5593877753ecc1e9051ed58c15168022037109f0d06e6068b7447966f751de8474641ad2b15ec37f4a9d159b02af68174012103e208f5403383c77d5832a268c9f71480f6e7bfbdfa44904becacfad66163ea31ffffffff01c8af0000000000001976a91458b7a60f11a904feef35a639b6048de8dd4d9f1c88ac00000000"),
   Prevout = hexstr_to_bin("76a914c564c740c6900b93afc9f1bdaef0a9d466adf6ee88ac"),
   ?assertEqual(error_result_tx_input_invalid, libconsensus:verify_script(TxBin, Prevout, 3, libconsensus:flags(verify_flags_p2sh))),
   ?assertEqual(error_result_tx_invalid, libconsensus:verify_script(crypto:strong_rand_bytes(40), Prevout, 0, 0)).


libconsensus_test_() -> 
  {foreach,
  fun start/0,
  fun stop/1,
   [
		{"Verify p2pkh script", fun p2pkh/0},
		{"Multilpe input tx", fun scripts1/0},
		{"OP_CODESEPARATOR", fun scripts2/0},
		{"OP_CHECKMULTISIG", fun scripts3/0},
		{"Testnet1", fun testnet1/0},
		{"Negative test", fun negative/0}
   ]
  }.


%%% Hexstr to bin
hexstr_to_bin(S) when is_binary(S) ->
	hexstr_to_bin(erlang:binary_to_list(S));

hexstr_to_bin(S) ->
  hexstr_to_bin(S, []).
hexstr_to_bin([], Acc) ->
  list_to_binary(lists:reverse(Acc));
hexstr_to_bin([X,Y|T], Acc) ->
  {ok, [V], []} = io_lib:fread("~16u", [X,Y]),
  hexstr_to_bin(T, [V | Acc]).

