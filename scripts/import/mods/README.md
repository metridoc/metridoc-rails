# README for `mods` import workflow

This document describes the workflow for loading [marc21 XML](https://www.loc.gov/standards/marcxml/) records into MetriDoc in the `marc_book_mods` model.

## Requirements

* Marc XML file(s)
* A Linux-based or [Dockerized](https://docs.docker.com/) environment

## Usage

1. Split the XML file into smaller XML files that are manageable to run against an XSLT script.  Example:

  ```bash
  ./split_marc_xml.sh $MARC_XML_FILE $BATCH_SIZE
  ```

  Where `$MARC_XML_FILE` is the source Marc XML file to be split into smaller files, and `$BATCH_SIZE` is the number of records per file to be included in each smaller file.

  NOTE: This bash script **will not** work in a Mac development environment, and will silently fail.  For local development, a Linux environment or script execution from within a Docker container is recommended.

2. The smaller split records will be in this directory.  Move them into the `artifacts` subdirectory.

3. Use the [`convert_and_import_xml`](convert_and_import_xml.rb) script to transform the smaller Marc XML files into MODS XML one at a time, then import each transformed XML file one at a time into MetriDoc.  Point the script to the `artifacts` directory to pick up the untransformed files, and the temporary directory where the transformed files will go so that the import rake task can pick them up.

  Example:

  ```bash
  ruby convert_and_import_xml.rb artifacts /tmp
  ```

  You should see output something like the following:

  ```bash
  processing artifacts/part-00000_0.xml...
  artifacts/part-00000_0.xml processed.
  processing artifacts/part-00000_1.xml...
  artifacts/part-00000_1.xml processed.
  processing artifacts/part-00000_2.xml...
  # and so on
  ```
