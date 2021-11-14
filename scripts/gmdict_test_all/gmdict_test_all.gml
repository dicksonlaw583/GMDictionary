///@func gmdict_test_all()
function gmdict_test_all() {
	global.__test_fails__ = 0;
	var timeA, timeB;
	timeA = current_time;
	
	/* v Tests here v */
	gmdict_test_check_word();
	gmdict_test_pick_word();
	/* ^ Tests here ^ */
	
	timeB = current_time;
	show_debug_message("GMDictionary tests done in " + string(timeB-timeA) + "ms.");
	return global.__test_fails__ == 0;
}
