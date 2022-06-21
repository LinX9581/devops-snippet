The Analytics Edge connectors for Google Analytics provide the ability to enter a cell reference pointing to an Excel worksheet cell containing the filter expression. Enter the expression portion only — do not include the “&filters=” prefix.

The same expression with work with both the v3 API and the v4 API, but there are some subtle differences. The Analytics Edge connectors will automatically adjust for those differences for you [the Free Google Analytics connector uses the v3 API; the Google Analytics Pro connector uses the v4 API].

Filters
ga:medium%3D%3Dreferral

The filters query string parameter restricts the data returned from your request. To use the filters parameter, supply a dimension or metric on which to filter, followed by the filter expression. For example, the following query requests ga:pageviews and ga:browser for view (profile) 12134, where the ga:browser dimension starts with the string Firefox:

ga:browser%3D~%5EFirefox
Filtered queries restrict the rows that do (or do not) get included in the result. Each row in the result is tested against the filter: if the filter matches, the row is retained and if it doesn’t match, the row is dropped.

URL Encoding: Filter operators and expressions must be URL encoded.
Dimension filtering: Filtering occurs before any dimensions are aggregated, so that the returned metrics represent the total for only the relevant dimensions. In the example above, the number of pageviews would be only those pageviews where Firefox is the browser.
Metrics filtering: Filtering on metrics occurs after the metrics are aggregated.
Valid combinations: You can filter for a dimension or metric that is not part of your query, provided all dimensions/metrics in the request and the filter are valid combinations. For example, you might want to query for a dated list of pageviews, filtering on a particular browser. See the Dimensions and Metrics Reference for more information. The Analytics Edge connectors will grey-out fields that are not valid.
Filter Syntax
A single filter uses the form:

ga:name operator expression
In this syntax:

name — the name of the dimension or metric to filter on. For example: ga:pageviews filters on the pageviews metric.
operator — defines the type of filter match to use. Operators are specific to either dimensions or metrics.
expression — states the values to be included in or excluded from the results. Expressions use regular expression syntax.
Filter Operators
There are six filter operators for dimensions and six filter operators for metrics. The operators must be URL-encoded in order to be included in URL query strings.

Metric Filters
OPERATOR	DESCRIPTION	URL ENCODED	EXAMPLES
==	Equals	%3D%3D	Return results where the time on the page is exactly ten seconds:
ga:timeOnPage%3D%3D10
!=	Does not equal	!%3D	Return results where the time on the page is not ten seconds:
ga:timeOnPage!%3D10
>	Greater than	%3E	Return results where the time on the page is strictly greater than ten seconds:
ga:timeOnPage%3E10
<	Less than	%3C	Return results where the time on the page is strictly less than ten seconds:
ga:timeOnPage%3C10
>=	Greater than or equal to	%3E%3D	Return results where the time on the page is ten seconds or more:
ga:timeOnPage%3E%3D10
<=	Less than or equal to	%3C%3D	Return results where the time on the page is ten seconds or less:
ga:timeOnPage%3C%3D10
Dimension Filters
OPERATOR	DESCRIPTION	URL ENCODED	EXAMPLE
==	Exact match	%3D%3D	Aggregate metrics where the city is Irvine:
ga:city%3D%3DIrvine
!=	Does not match	!%3D	Aggregate metrics where the city is not Irvine:
ga:city!%3DIrvine
=@	Contains substring	%3D@	Aggregate metrics where the city contains York:
ga:city%3D@York
!@	Does not contain substring	!@	Aggregate metrics where the city does not contain York:
ga:city!@York
=~	Contains a match for the regular expression	%3D~	Aggregate metrics where the city starts with New:
ga:city%3D~%5ENew.* 
(%5E is the URL encoded from of the ^ character that anchors a pattern to the beginning of the string.)
!~	Does not match regular expression	!~	Aggregate metrics where the city does not start with New:
ga:city!~%5ENew.*
Filter Expressions
There are a few important rules for filter expressions:

URL encoding — Characters such as & must be URL-encoded. A good online utility to do this can be found at https://www.urlencoder.org/
Reserved characters — The semicolon and comma must be backslash-escaped when they appear in an expression:
semicolon \;
comma \,
Regular Expressions — You can also use regular expressions in filter expressions using the =~ and !~operators. Their syntax is similar to Perl regular expressions and have these additional rules:
Maximum length of 128 characters — Regular expressions longer than 128 characters result in a 400 Bad Request status code returned from the server.
Case sensitivity — Regular expression matching is case-insensitive.
Combining Filters
Filters can be combined using OR and AND Boolean logic. This allows you to effectively extend the 128 character limit of a filter expression.

OR
The OR operator is defined using a comma (,). It takes precedence over the AND operator and may NOT be used to combine dimensions and metrics in the same expression.

Examples:

Country is either (United States OR Canada):
ga:country%3D%3DUnited%20States,ga:country%3D%3DCanada

Firefox users on (Windows OR Macintosh) operating systems:
ga:browser%3D%3DFirefox;ga:operatingSystem%3D%3DWindows,ga:operatingSystem%3D%3DMacintosh

AND
The AND operator is defined using a semi-colon (;). It is preceded by the OR operator and CAN be used to combine dimensions and metrics in the same expression.

Examples:

Country is United States AND the browser is Firefox:
ga:country%3D%3DUnited%20States;ga:browser%3D%3DFirefox

Country is United States AND language does not start with ‘en’ (using the regular expression ^en.*):
ga:country%3D%3DUnited%20States;ga:language!~%5Een.%2A

Operating system is (Windows OR Macintosh) AND browser is (Firefox OR Chrome):
ga:operatingSystem%3D%3DWindows,ga:operatingSystem%3D%3DMacintosh;ga:browser%3D%3DFirefox,ga:browser%3D%3DChrome

Country is United States AND sessions are greater than 5:
ga:country%3D%3DUnited%20States;ga:sessions%3E5