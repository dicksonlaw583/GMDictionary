# GMDictionary

GameMaker Studio 2.3+ library for word lookup in word games

## Overview

This library contains two utility classes for word lookups commonly found in word games:

- `CheckWordDictionary`: Dictionary class for checking the validity of given words.
- `PickWordDictionary`: Dictionary class for pulling random words out of a list.

These classes can then load word lists in batch from line-by-line text files, or one-by-one at runtime. To get you started, the library comes with two English language dictionaries.

## Requirements

- GameMaker Studio 2.3.3 or above

## Installation

- Go to the [Releases Page](https;//github.com/dicksonlaw583/GMDictionary/releases) to download the latest YYMPS package.
- In GameMaker Studio, select **Tools > Import Local Package**, and select the downloaded YYMPS package.
- Add everything under `Libraries/GMDictionary`.
- Depending on the way your project uses words, you may optionally add one of the dictionary lists under Included Files:
	- Unfiltered set of English words from [`dwyl/english-words`](https://github.com/dwyl/english-words/):
		- `dictionaries/full/full.txt`: The complete list of words.
		- `dictionaries/full_by_length/*.txt`: The list of words of a specific length.
		- `dictionaries/full_by_letter/*.txt`: The list of words starting with a specific letter.
	- Filtered set of English words of lengths 3-12 from the legacy game [*Scramble SG* by Gunther Serrano](http://web.archive.org/web/20060829012348if_/http://www.gamemaker.nl/games_edit.html), plus 108 two-letter English words.
		- `dictionaries/simple/full.txt`: The complete list of words.
		- `dictionaries/simple_by_length/*.txt`: The list of words of a specific length.
		- `dictionaries/simple_by_letter/*.txt`: The list of words starting with a specific letter.
- Confirm the import by clicking **Import**. *Note: If you intend to import into the current project, make sure that **Import all resources to a new project** is unchecked.*

## Basic Usage

### Example for `CheckWordDictionary`

#### Load the entire simple set
```
global.dictionary = new CheckWordDictionary(working_directory + "dictionaries/simple/full.txt");
```

#### Check if the user's input is a valid English word
```
var word = get_string("Enter a word:", "");
if (global.dictionary.check(word)) {
	show_message("\"" + word + "\" is a valid English word.");
} else {
	show_message("\"" + word + "\" is not a valid English word.");
}
```

### Example for `PickWordDictionary`

#### Load the 3-5 letter simple set
```
global.dictionary = new PickWordDictionary([
	working_directory + "dictionaries/simple_by_length/3.txt",
	working_directory + "dictionaries/simple_by_length/4.txt",
	working_directory + "dictionaries/simple_by_length/5.txt",
]);
```

#### Pick a random word
```
var wordOfTheDay = global.dictionary.pick();
show_message("Your word of the day is \"" + wordOfTheDay + "\"");
```

#### Pick 10 unique random words
```
var words = global.dictionary.pickN(10);
show_message("Your words are: " + string(words));
```

