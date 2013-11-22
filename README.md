SOCoP Importer
==================

Some ruby code to import metadata of ontologies and submissions from [socop.oor.net](http://socop.oor.net/).

Requirements
------------

You need Ruby 2.0, libxml2 and libxslt


Installation
------------

    git clone git://github.com/ontohub/socop.git
    cd socop_importer
    bundle install

Usage
-----

Start the interactive ruby console:

    ./console

Create a repository with all downloaded submissions:

    Socop.import_all

Now you can find the repository in ./workspace/.git
