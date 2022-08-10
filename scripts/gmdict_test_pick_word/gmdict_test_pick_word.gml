///@func gmdict_test_check_word()
function gmdict_test_check_word() {
	var dictionary;
	
	#region Initial setup
	dictionary = new CheckWordDictionary();
	assert_equal(dictionary.size, 0, "CheckWordDictionary setup failed!");
	assert_throws(method({ dict: dictionary }, function() {
		//Feather disable GM1013
		dict.check("a");
	}), new DictionaryTooSmallException(dictionary, 1), "CheckWordDictionary setup should throw error on lookup!");
	#endregion
	
	#region Add one word
	assert_equal(dictionary.add("hello"), 1, "CheckWordDictionary add return failed!");
	assert_equal(dictionary.size, 1, "CheckWordDictionary add failed!");
	assert(dictionary.check("hello"), "CheckWordDictionary should find added word!");
	assert_fail(dictionary.check("a"), "CheckWordDictionary should not find missing word!");
	#endregion
	
	#region Test single-file loading
	assert_equal(dictionary.load(working_directory + "dictionaries/test/abc.txt"), 3, "CheckWordDictionary load return value 1a failed!");
	assert_equal(dictionary.size, 4, "CheckWordDictionary load new size 1b failed!");
	assert(dictionary.check("a"), "CheckWordDictionary 1c should find a!");
	assert_fail(dictionary.check("d"), "CheckWordDictionary 1d should not find d!");
	assert_fail(dictionary.check("g"), "CheckWordDictionary 1e should not find g!");
	assert_fail(dictionary.check("j"), "CheckWordDictionary 1f should not find j!");
	#endregion
	
	#region Test multi-file array loading
	assert_equal(dictionary.load([working_directory + "dictionaries/test/def.txt", working_directory + "dictionaries/test/ghi.txt"]), 6, "CheckWordDictionary load return value 2a failed!");
	assert_equal(dictionary.size, 10, "CheckWordDictionary load new size 2b failed!");
	assert(dictionary.check("a"), "CheckWordDictionary 2c should find a!");
	assert(dictionary.check("d"), "CheckWordDictionary 2d should find d!");
	assert(dictionary.check("g"), "CheckWordDictionary 2e should find g!");
	assert_fail(dictionary.check("j"), "CheckWordDictionary 2f should not find j!");
	#endregion
	
	#region Test multi-file struct loading
	var loadStruct = {};
	loadStruct[$ working_directory + "dictionaries/test/abc.txt"] = 0;
	loadStruct[$ working_directory + "dictionaries/test/def.txt"] = 0;
	loadStruct[$ working_directory + "dictionaries/test/ghi.txt"] = 0;
	loadStruct[$ working_directory + "dictionaries/test/jkl.txt"] = 1;
	assert_equal(dictionary.load(loadStruct), 3, "CheckWordDictionary load return value 3a failed!");
	assert_equal(dictionary.size, 13, "CheckWordDictionary load new size 3b failed!");
	assert(dictionary.check("a"), "CheckWordDictionary 3c should find a!");
	assert(dictionary.check("d"), "CheckWordDictionary 3d should find d!");
	assert(dictionary.check("g"), "CheckWordDictionary 3e should find g!");
	assert(dictionary.check("j"), "CheckWordDictionary 3f should find j!");
	#endregion
	
	#region Add multiple words
	assert_equal(dictionary.add(["x", "y", "z"]), 3, "CheckWordDictionary add multiple return failed!");
	assert_equal(dictionary.size, 16, "CheckWordDictionary add multiple failed!");
	#endregion
}
