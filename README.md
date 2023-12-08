# juanelas/languagetool

A docker image to run a custom server with the latest stable [LanguageTool](https://languagetool.org/), a style and grammar proofreading software for English, French, German, and a lot of other languages. You can think of LanguageTool as a software to detect errors that a simple spell checker cannot detect, e.g. mixing up there/their, no/now etc. It can also detect some grammar mistakes.

Supported languages are: Arabic, Asturian, Belarusian, Breton, Catalan, Chinese, Danish, Dutch, English, Esperanto, French, Galician, German, Greek, Italian, Japanese, Khmer, Persian, Polish, Portuguese, Romanian, Russian, Slovak, Slovenian, Spanish, Swedish, Tagalog, Tamil, Ukrainian. Please note that the level of support differs a lot between languages.

## Usage

LanguageTool can be just run in port 8081 (default) as:

```sh
docker run --rm -it -p 8081:8081/tcp juanelas/languagetool --public
```

## n-grams

LanguageTool can make use of large n-gram data sets to detect errors with words that are often confused, like their and there.

> n-grams is currently only available for Dutch, English, French, German, and Spanish (plus some data for untested languages).

To add [n-grams](https://dev.languagetool.org/finding-errors-using-n-gram-data) to your dockerised LanguageTool:

1. Download the data for the languages you want (~8 GB each!) from <https://languagetool.org/download/ngram-data/>
2. Unzip it. Depending on the language downloaded you will have a directory named `de`, `en`, `es`, `fr`, or `nl`.
3. Place the directories of ngrams for every language in a directory called `ngrams`.
4. Assuming that `ngrams` is in your current directory, you can start LanguageTool with n-grams support as:

   ```sh
   docker run --rm -it -p 8081:8081/tcp -v ngrams:/ngrams juanelas/languagetool --public
   ```

## word2vec

Alternatively to n-gram you could use the experimental word2vec model by [Mikolov et al](https://proceedings.neurips.cc/paper_files/paper/2013/file/9aa42b31882ec039965f3c4923ce901b-Paper.pdf), which should get similar results than the n-grams approach with just 70 MB per downloaded language.
> word2vec is currently only available for English, German, and Portuguese.

1. Download the data for the languages you want from <https://languagetool.org/download/word2vec/>
2. Unzip it. Depending on the language downloaded you will have a directory named `de`, `en`, or `pt`.
3. Place the directories of word2vec for every language in a directory called `word2vec`.
4. Assuming that `word2vec` is in your current directory, you can start LanguageTool with word2vec support as:

   ```sh
   docker run --rm -it -p 8081:8081/tcp -v word2vec:/word2vec juanelas/languagetool --public
   ```

## config properties file

Additionally you can tune your server with a Java property file (one key=value entry per line) with values for:

- `mode` - `LanguageTool` or `AfterTheDeadline` (DEPRECATED) for emulation of After the Deadline output (optional)
- `afterTheDeadlineLanguage` - language code like `en` or `en-GB` (required if `mode` is `AfterTheDeadline`) - DEPRECATED
- `maxTextLength` - maximum text length, longer texts will cause an error (optional)
- `maxTextHardLength` - maximum text length, applies even to users with a special secret token parameter (optional)
- `secretTokenKey` - secret JWT token key, if set by user and valid, maxTextLength can be increased by the user (optional)
- `maxCheckTimeMillis` - maximum time in milliseconds allowed per check (optional)
- `maxErrorsPerWordRate` - checking will stop with error if there are more rules matches per word (optional)
- `maxSpellingSuggestions` - only this many spelling errors will have suggestions for performance reasons (optional, affects Hunspell-based languages only)
- `maxCheckThreads` - maximum number of threads working in parallel (optional)
- `cacheSize` - size of internal cache in number of sentences (optional, default: `0`)
- `requestLimit` - maximum number of requests per requestLimitPeriodInSeconds (optional)
- `requestLimitInBytes` - maximum aggregated size of requests per requestLimitPeriodInSeconds (optional)
- `timeoutRequestLimit` - maximum number of timeout request (optional)
- `requestLimitPeriodInSeconds` - time period to which requestLimit and timeoutRequestLimit applies (optional)
- `maxWorkQueueSize` - reject request if request queue gets larger than this (optional)
- `warmUp` - set to `true` to warm up server at start, i.e. run a short check with all languages (optional)
- `blockedReferrers` - a comma-separated list of HTTP referrers (and Origin headers) that are blocked and will not be served (optional)
- `disabledRuleIds` - a comma-separated list of rule ids that are turned off for this server (optional)

If your file is named `config.properties`, you can pass it to your LanguageTool as:

```sh
docker run --rm -it -p 8081:8081/tcp -v config.properties:/config.properties juanelas/languagetool --public
```
