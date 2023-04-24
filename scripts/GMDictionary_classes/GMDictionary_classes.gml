///@class CheckWordDictionary([source])
///@arg {string,array<string>,struct,undefined} [source] (Optional) Source file(s) to load from. See `load(source)` for details.
///@desc Constructor for a dictionary optimized for checking the existence of a word in a list.
function CheckWordDictionary(source=undefined) constructor {
	///@func load(source)
	///@self CheckWordDictionary
	///@arg {string,array<string>,struct} source
	///@desc Load words into the dictionary from the given source. Return the number of words loaded.
	///
	/// - If source is a string: Load from the given file.
	///
	/// - If source is an array: Load from each file in the array.
	///
	/// - If source is a struct: Load from each file in the struct's keys where the corresponding value is true.
	static load = function(source) {
		var n = 0;
		if (is_string(source)) {
			var f;
			for (f = file_text_open_read(source); !file_text_eof(f); file_text_readln(f)) {
				var w = file_text_read_string(f);
				self.data[$ w] = 1;
				++n;
			}
			file_text_close(f);
			self.size += n;
		} else if (is_array(source)) {
			//Feather disable GM1061
			var sourceSize = array_length(source);
			for (var i = 0; i < sourceSize; ++i) {
				//Feather disable GM1010
				n += self.load(source[i]);
			}
		} else if (is_struct(source)) {
			var sourceKeys = variable_struct_get_names(source);
			var sourceSize = array_length(sourceKeys);
			for (var i = 0; i < sourceSize; ++i) {
				var k = sourceKeys[i];
				if (source[$ k]) {
					//Feather disable GM1041
					n += self.load(k);
				}
			}
		} else {
			show_error("Invalid type for source in CheckWordDictionary.load(source).", true);
		}
		return n;
	};
	
	///@func add(word)
	///@self CheckWordDictionary
	///@arg {string,array<string>} word The string or array of strings to add into the dictionary
	///@return {real}
	///@desc Add a word or an array of words into the dictionary. Return the number of words added.
	static add = function(word) {
		if (is_string(word)) {
			self.data[$ word] = 1;
			++self.size;
			return 1;
		} else if (is_array(word)) {
			//Feather disable GM1061
			var n = array_length(word);
			for (var i = n-1; i >= 0; --i) {
				self.data[$ word[i]] = 1;
			}
			self.size += n;
			return n;
		}
	};
	
	///@func check(word)
	///@self CheckWordDictionary
	///@arg {string} word The string to check
	///@return {bool}
	///@desc Return whether the given word is in the dictionary.
	static check = function(word) {
		if (self.size <= 0) {
			throw new DictionaryTooSmallException(self, 1);
		}
		return variable_struct_exists(self.data, word);
	};
	
	// Setup
	data = {};
	size = 0;
	if (!is_undefined(source)) {
		self.load(source);
	}
}

///@class PickWordDictionary([source])
///@arg {string,array<string>,struct,undefined} [source] (Optional) Source file(s) to load from. See `load(source)` for details.
///@desc Constructor for a dictionary optimized for picking a random word from a list.
function PickWordDictionary(source=undefined) constructor {
	///@func load(source)
	///@self PickWordDictionary
	///@arg {string,array<string>,struct} source
	///@desc Load words into the dictionary from the given source. Return the number of words loaded.
	///
	/// - If source is a string: Load from the given file.
	///
	/// - If source is an array: Load from each file in the array.
	///
	/// - If source is a struct: Load from each file in the struct's keys where the corresponding value is true.
	static load = function(source) {
		var n = 0;
		if (is_string(source)) {
			var f;
			for (f = file_text_open_read(source); !file_text_eof(f); file_text_readln(f)) {
				var w = file_text_read_string(f);
				array_push(self.data, w);
				++n;
			}
			file_text_close(f);
			self.size += n;
		} else if (is_array(source)) {
			//Feather disable GM1061
			var sourceSize = array_length(source);
			for (var i = 0; i < sourceSize; ++i) {
				//Feather disable GM1010
				n += self.load(source[i]);
			}
		} else if (is_struct(source)) {
			var sourceKeys = variable_struct_get_names(source);
			var sourceSize = array_length(sourceKeys);
			for (var i = 0; i < sourceSize; ++i) {
				var k = sourceKeys[i];
				if (source[$ k]) {
					//Feather disable GM1041
					n += self.load(k);
				}
			}
		} else {
			show_error("Invalid type for source in CheckWordDictionary.load(source).", true);
		}
		return n;
	};
	
	///@func add(word)
	///@self PickWordDictionary
	///@arg {string,array<string>} word The string or array of strings to add into the dictionary
	///@return {real}
	///@desc Add a word or an array of words into the dictionary. Return the number of words added.
	static add = function(word) {
		if (is_string(word)) {
			array_push(self.data, word);
			++self.size;
			return 1;
		} else {
			var n = array_length(word);
			array_copy(self.data, self.size, word, 0, n);
			self.size += n;
			return n;
		}
	};
	
	///@func pick()
	///@self PickWordDictionary
	///@return {string}
	///@desc Return a random word from the dictionary.
	static pick = function() {
		if (self.size <= 0) {
			throw new DictionaryTooSmallException(self, 1);
		}
		return self.data[irandom(self.size-1)];
	};
	
	///@func pickN(n, [largeMode])
	///@self PickWordDictionary
	///@arg {real} n Number of words to pick
	///@arg {bool} largeMode
	///@return {array<string>}
	///@desc Return an array of n random unique words from the dictionary.
	///
	/// - If largeMode is false (default): Pick n times randomly from the dictionary and re-pick on duplication.
	///
	/// - If largeMode is true: Shuffle a copy of the dictionary's inner data, and pick the first n words.
	static pickN = function(n, largeMode=false) {
		if (self.size < n) {
			throw new DictionaryTooSmallException(self, n);
		}
		var result;
		if (largeMode) {
			result = array_create(self.size);
			array_copy(result, 0, self.data, 0, self.size);
			for (var i = self.size-1; i >= 1; --i) {
				var j = irandom(i);
				var temp = result[i];
				result[@ i] = result[j];
				result[@ j] = temp;
			}
			array_resize(result, n);
		} else {
			result = array_create(n);
			var seenWords = {};
			var pickedWord;
			for (var i = n-1; i >= 0; --i) {
				do {
					pickedWord = self.data[irandom(self.size-1)];
				} until (!variable_struct_exists(seenWords, pickedWord));
				seenWords[$ pickedWord] = 1;
				result[@ i] = pickedWord;
			}
		}
		//Feather disable GM1045
		return result;
		//Feather enable GM1045
	};
	
	// Setup
	data = [];
	size = 0;
	if (!is_undefined(source)) {
		self.load(source);
	}
}
