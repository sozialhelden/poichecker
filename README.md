# Notice:The development of this project has been stopped.


# POIchecker: Dedupe GEO-Data

[![Build Status](https://travis-ci.org/sozialhelden/poichecker.png?branch=master)](https://travis-ci.org/sozialhelden/poichecker)
[![Dependency Status](https://gemnasium.com/sozialhelden/poichecker.png)](https://gemnasium.com/sozialhelden/poichecker)
[![Coverage Status](https://coveralls.io/repos/sozialhelden/poichecker/badge.png)](https://coveralls.io/r/sozialhelden/poichecker)
[![Climate](https://codeclimate.com/github/sozialhelden/poichecker.png)](https://codeclimate.com/github/sozialhelden/poichecker)
[![License](http://img.shields.io/license/MIT.png?color=green) ](https://github.com/sozialhelden/poichecker/blob/master/LICENSE)
[![Gittip ](http://img.shields.io/gittip/sozialhelden.png)](https://gittip.com/sozialhelden)

POIchecker is an interactive webbased import-tool to manually match and deduplicate geo datasets between external sources and the OpenStreetMap.

With more than 1 million contributors the OpenStreetMap is the largest free and open database for geo-spatial information. Importing new data into the OpenStreetMap most likely creates duplicate data entries. To avoid this undesired effect POIchecker provides a web interface to match and merge every entry manually.

As a first step the Nomitim Search engine is queried for potential candidates that make for a duplicate entry. Then comparison view with a small map provides a good source for humas to decide wether this POI is already in the OpenStreetMap or not.

If a candidated is found, the next step a merge view is presented which enables the use to mix and match information of the two data entries to produce the new version of the data to be sent to the OpenStreetMap.

That's it, resume with the next POI.
