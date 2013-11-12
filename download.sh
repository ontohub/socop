#!/bin/sh -e
#
# Downloads metadata and versions and saves it into the ./data directory.
#

apikey='11111111-9dd1-11e0-a996-115056bd0024'
endpoint='http://76.14.77.31:8080/bioportal/'
datadir="`dirname $0`/data"
id_pattern='s/[^0-9]*\([0-9]\+\).*/\1/'

mkdir -p $datadir

download () { 
  # directory to store the file
  output=$datadir/$2
  mkdir -p `dirname $output`

  echo downloading $1
  curl --silent "$endpoint$1?apikey=$apikey" > $output
}

# Download some metadata
download ontologies ontologies.xml
download categories categories.xml
download groups     groups.xml

# Download versions metadata
for id in `grep "<ontologyId>" $datadir/ontologies.xml | sed "$id_pattern"`; do
  download ontologies/versions/$id versions/$id.xml
done

# Download version files
for id in `grep --no-filename "<id>" $datadir/versions/*.xml | sed "$id_pattern"`; do
  download ontologies/download/$id version_files/$id
done
