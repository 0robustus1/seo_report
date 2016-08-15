# Change Log

This change log contains information about the changes introduced as part of
specific releases. It adheres to the guidelines outlined by
[keepachangelog](http://keepachangelog.com/en/0.3.0/).

## [unreleased]
### Added
- Minor changes regarding housekeeping:
  - Cache bundler/gems on travis
  - Add badge for travis build-jobs to README
  - Add badge for current rubygems version to README
- Add specs for:
  - the opengraph-data extraction

## [0.1.3] — 2016-08-14
### Added
- Provide error message, without internal stacktrace information when the
  command fails for unrecoverable reasons. Also introduces the
  `SEO_REPORT_DEBUG` environment variable in order to show the stacktrace if
  failure occurs, for... well debugging.
- Add error-integration to json/internal-struct for microdata. This allows the
  recognition and handling of errors regarding microdata in the document.
- Specify minimum required ruby-version of **2.0.0**. It wouldn't really have
  worked with anything less than /1.9.3/ before, but specifying it exactly makes
  it easier to test for and to adhere to.
- The starts of a real test-suite. Currrently there are only specs for the main
  extractions, meaning SEO (canonical and robots meta) and HEAD (title and meta
  description). But the start has been made and the test suite will grow over
  the next releases up to 0.2.0, at which point there should be at least an 85%
  coverage.
### Fixed
- Don't fail as easily when parsing microdata information. Seeing as this a
  reporting-tool, that should also display information whether something is
  valid (or *ok*) or not, we need to handle most errors in the html-document
  gracefully in order to live to report about it.

## [0.1.2] — 2016-08-10
### Added
- Always send an appropriate User-Agent: `seo-report/0.1.2 Net::HTTP`.
  `Net::HTTP` is used as the underlying library to perform http-requests, which
  is why it is listed. However the actual user-agent is seo-report itself. The
  number specifies the version of seo-report that was used to perform the
  request.
  
### Changed
- Handle path-only redirects and mark them as warnings.
  While they are supported they don't represent a full URL, which
  is what is supposed to be present in the `LOCATION` header.

## [0.1.1] — 2016-08-07
This marks the first release of the seo_report gem, which provides the
`seo-report` binary. This software is licensed under LGPL-3.0.
