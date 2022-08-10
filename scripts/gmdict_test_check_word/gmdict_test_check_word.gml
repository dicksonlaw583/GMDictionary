///@func gmdict_test_pick_word()
function gmdict_test_pick_word() {
	var dictionary, expected;
	var pickNResult;
	
	#region Initial setup
	dictionary = new PickWordDictionary();
	assert_equal(dictionary.size, 0, "PickWordDictionary setup failed!");
	assert_throws(method({ dict: dictionary }, function() {
		//Feather disable GM1013
		dict.pick();
	}), new DictionaryTooSmallException(dictionary, 1), "PickWordDictionary setup should throw error on pick!");
	assert_throws(method({ dict: dictionary }, function() {
		//Feather disable GM1013
		dict.pickN(2);
	}), new DictionaryTooSmallException(dictionary, 2), "PickWordDictionary setup should throw error on pickN!");
	#endregion
	
	#region Add one word
	assert_equal(dictionary.add("waahoo"), 1, "PickWordDictionary add return failed!");
	assert_equal(dictionary.size, 1, "PickWordDictionary add failed!");
	assert_equal(dictionary.pick(), "waahoo", "PickWordDictionary should pick successfully!");
	assert_equal(dictionary.pickN(1), ["waahoo"], "PickWordDictionary should pickN successfully!");
	assert_equal(dictionary.pickN(1, true), ["waahoo"], "PickWordDictionary should pickN successfully!");
	#endregion
	
	#region Test single-file loading
	expected = ["a", "b", "c", "waahoo"];
	assert_equal(dictionary.load(working_directory + "dictionaries/test/abc.txt"), 3, "PickWordDictionary load return value 1a failed!");
	assert_equal(dictionary.size, 4, "PickWordDictionary load new size 1b failed!");
	repeat (20) {
		assert_contains(expected, dictionary.pick(), "PickWordDictionary 1c pick should return something valid!");
	}
	pickNResult = dictionary.pickN(4);
	array_sort(pickNResult, true);
	assert_equal(pickNResult, expected, "PickWordDictionary 1d pickN failed!");
	pickNResult = dictionary.pickN(4, true);
	array_sort(pickNResult, true);
	assert_equal(pickNResult, expected, "PickWordDictionary 1e pickN largeMode failed!");
	#endregion
	
	#region Test multi-file array loading
	expected = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "waahoo"];
	assert_equal(dictionary.load([working_directory + "dictionaries/test/def.txt", working_directory + "dictionaries/test/ghi.txt"]), 6, "PickWordDictionary load return value 2a failed!");
	assert_equal(dictionary.size, 10, "PickWordDictionary load new size 2b failed!");
	repeat (20) {
		assert_contains(expected, dictionary.pick(), "PickWordDictionary 2c pick should return something valid!");
	}
	pickNResult = dictionary.pickN(10);
	array_sort(pickNResult, true);
	assert_equal(pickNResult, expected, "PickWordDictionary 2d pickN failed!");
	pickNResult = dictionary.pickN(10, true);
	array_sort(pickNResult, true);
	assert_equal(pickNResult, expected, "PickWordDictionary 2e pickN largeMode failed!");
	#endregion
	
	#region Test multi-file struct loading
	expected = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "waahoo"];
	var loadStruct = {};
	loadStruct[$ working_directory + "dictionaries/test/abc.txt"] = 0;
	loadStruct[$ working_directory + "dictionaries/test/def.txt"] = 0;
	loadStruct[$ working_directory + "dictionaries/test/ghi.txt"] = 0;
	loadStruct[$ working_directory + "dictionaries/test/jkl.txt"] = 1;
	assert_equal(dictionary.load(loadStruct), 3, "PickWordDictionary load return value 3a failed!");
	assert_equal(dictionary.size, 13, "PickWordDictionary load new size 3b failed!");
	repeat (20) {
		assert_contains(expected, dictionary.pick(), "PickWordDictionary 3c pick should return something valid!");
	}
	pickNResult = dictionary.pickN(13);
	array_sort(pickNResult, true);
	assert_equal(pickNResult, expected, "PickWordDictionary 3d pickN failed!");
	pickNResult = dictionary.pickN(13, true);
	array_sort(pickNResult, true);
	assert_equal(pickNResult, expected, "PickWordDictionary 3e pickN largeMode failed!");
	#endregion
	
	#region Add multiple words
	assert_equal(dictionary.add(["x", "y", "z"]), 3, "PickWordDictionary add multiple return failed!");
	assert_equal(dictionary.size, 16, "PickWordDictionary add multiple failed!");
	#endregion
}
