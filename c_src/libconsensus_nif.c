/* Copyright, 2015 Matthew Branton
 * Distributed under the MIT license located in the LICENSE file.
 *
 * */

#include "erl_nif.h"

#include "consensus/consensus.h"
#include <bitcoin/consensus/export.hpp>
#include <stdio.h>
#include <stdint.h>


// Prototypes


namespace libbitcoin {
namespace consensus {

static ERL_NIF_TERM result_to_atom(ErlNifEnv* env, verify_result_type result);

static int
load(ErlNifEnv* env, void** priv, ERL_NIF_TERM load_info)
{
    return 0;
}

static int
upgrade(ErlNifEnv* env, void** priv, void** old_priv, ERL_NIF_TERM load_info)
{
    return 0;
}

static void
unload(ErlNifEnv* env, void* priv)
{
    return;
}



static ERL_NIF_TERM
verify_script(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
	uint32_t tx_input_index, flags;
	verify_result_type result;
	ErlNifBinary transaction, prevout_script;

	if (!enif_inspect_binary(env, argv[0], &transaction)) {
       return enif_make_badarg(env);
    }

	if (!enif_inspect_binary(env, argv[1], &prevout_script)) {
       return enif_make_badarg(env);
    }

    if (!enif_get_uint(env, argv[2], &tx_input_index)) {
    	return 0;
	}

    if (!enif_get_uint(env, argv[3], &flags)) {
    	return 0;
	}

	result = verify_script(transaction.data, 
    transaction.size, prevout_script.data, 
    prevout_script.size, tx_input_index, flags);
    return result_to_atom(env, result);
}

static ERL_NIF_TERM result_to_atom(ErlNifEnv* env, verify_result_type result)
{
    switch ((ScriptError_t)result)
    {
        // Logical result
        case verify_result_eval_true:
        	return enif_make_atom(env, "true");
        case verify_result_eval_false:
        	return enif_make_atom(env, "false");

        // Max size errors
        case verify_result_script_size:
        	return enif_make_atom(env, "error_script_size");
        case verify_result_push_size:
        	return enif_make_atom(env, "error_push_size");
        case verify_result_op_count:
        	return enif_make_atom(env, "error_op_count");
        case verify_result_stack_size:
        	return enif_make_atom(env, "error_stack_size");
        case verify_result_sig_count:
        	return enif_make_atom(env, "error_sig_count");
        case verify_result_pubkey_count:
        	return enif_make_atom(env, "error_pubkey_count");

        // Failed verify operations
        case verify_result_verify:
        	return enif_make_atom(env, "error_verify");
        case verify_result_equalverify:
        	return enif_make_atom(env, "error_equal_verify");
        case verify_result_checkmultisigverify:
        	return enif_make_atom(env, "error_checkmultisigverify");
        case verify_result_checksigverify:
        	return enif_make_atom(env, "error_checksigverify");
        case verify_result_numequalverify:
        	return enif_make_atom(env, "error_numequalverify");

        // Logical/Format/Canonical errors
        case verify_result_bad_opcode:
        	return enif_make_atom(env, "error_bad_opcode");
        case verify_result_disabled_opcode:
        	return enif_make_atom(env, "error_disabled_opcode");
        case verify_result_invalid_stack_operation:
        	return enif_make_atom(env, "error_invalid_stack_operation");
        case verify_result_invalid_altstack_operation:
        	return enif_make_atom(env, "error_invalid_altstack_operation");
        case verify_result_unbalanced_conditional:
        	return enif_make_atom(env, "error_unbalanced_conditional");

        case verify_result_tx_invalid:
        	return enif_make_atom(env, "error_result_tx_invalid");

        case verify_result_tx_input_invalid:
        	return enif_make_atom(env, "error_result_tx_input_invalid");

        case verify_result_tx_size_invalid:
        	return enif_make_atom(env, "error_result_tx_size_invalid");

        // BIP62
        case verify_result_sig_hashtype:
        	return enif_make_atom(env, "error_sig_hashtype");
        case verify_result_sig_der:
        	return enif_make_atom(env, "error_sig_der");
        case verify_result_minimaldata:
        	return enif_make_atom(env, "error_sig_minimaldata");
        case verify_result_sig_pushonly:
        	return enif_make_atom(env, "error_sig_pushonly");
        case verify_result_sig_high_s:
        	return enif_make_atom(env, "error_sig_high_s");
        case verify_result_sig_nulldummy:
        	return enif_make_atom(env, "error_sig_nulldummy");
        case verify_result_pubkeytype:
        	return enif_make_atom(env, "error_pubkeytype");
        //case verify_result_cleanstack:
        //    return verify_result_cleanstack;

        // Softfork safeness
        case verify_result_discourage_upgradable_nops:
        	return enif_make_atom(env, "error_discourage_upgradable_nops");

        // Other
        case verify_result_op_return:
        	return enif_make_atom(env, "error_op_return");
        default:
        	return enif_make_atom(env, "result_unknown_error");
    }
}


static ErlNifFunc nif_funcs[] = {
    {"verify_script", 4, verify_script}
};



ERL_NIF_INIT(libconsensus, nif_funcs, &load, NULL, &upgrade, &unload);

}
}
