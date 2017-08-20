\name{NEWS}
\title{NEWS file for the selectr package}
\encoding{UTF-8}

\section{Changes in version 0.3-1}{
  \subsection{MINOR CHANGES}{
     \itemize{

      \item Enabled partial matching on the translator argument to
      \code{css_to_xpath()}. Instead of defaulting to a generic translator,
      a non-matching argument will be returned with an error.

      \item Introduced many more unit tests via the \pkg{covr} package.
      This enabled dead code to be trimmed and also identified areas of code
      which needed improvement. Minor enhancements include: tolerate
      whitespace within a \code{:not()}, more consistent results returned
      from parser methods, improvements to argument parsing.

     }
  }

  \subsection{BUG FIXES}{
    \itemize{

      \item The \code{|=} attribute matching operator was not being parsed
      correctly for the generic translator.

      \item Handle scenario where a CSS comment is unclosed. Results in
      everything after the comment start to be removed (which may or may
      not result in a valid selector).

    }
  }
}

\section{Changes in version 0.3-0}{
  \subsection{MAJOR CHANGES}{
    \itemize{

      \item Added support for documents from the \pkg{xml2} package.

      \item selectr now also does not strictly depend on the XML
      package. If either the \pkg{XML} or \pkg{xml2} packages are
      present (which are required for the \code{querySelector} methods
      to work) then \code{querySelector} will begin to work for them.
      This also enables selectr to be used for translation-only.

    }
  }

  \subsection{BUG FIXES}{
    \itemize{

      \item Improve support for nth-*(an+b) selectors. Ported from
      cssselect.

    }
  }
}

\section{Changes in version 0.2-3}{
  \subsection{MINOR CHANGES}{
    \itemize{

      \item Code cleanup contributed by Kun Ren (#1).

      \item Updated DESCRIPTION to include URL and BugReports fields.
      Also update email address.

    }
  }
  \subsection{BUG FIXES}{
    \itemize{

      \item Fix behaviour for nth-*(an+b) pseudo-class selectors for
      negative a's. Contributed to cssselect by Paul Tremberth,
      ported to R.

      \item Escape delimiting characters to support new version of the
      stringr package. Probably should have been done in the first place.
      Reported by Hadley Wickham (#5).

    }
  }
}

\section{Changes in version 0.2-2}{
  \subsection{MINOR CHANGES}{
    \itemize{

      \item Corrected licence to BSD 3 clause. This was the licence in
      use previously, but has now been made more explicit.

      \item Removed 'Enhances' field because we import functions from
      \pkg{XML}. This choice is made because \pkg{XML} is a required
      package, rather than an optional package that can be worked with.
      This and the previous change have been made to keep up with recent
      changes in R-devel.

    }
  }
}

\section{Changes in version 0.2-1}{
  \subsection{MINOR FEATURES}{
    \itemize{

      \item Added a 'CITATION' file which cites a technical report on
      the package.

      \item \code{show()} methods are now available on internal objects,
      making interactive extensibility and bug-fixing easier. This is
      simply wrapping the \code{repr()} methods (mirroring the Python
      source) that the same objects have.

    }
  }
  \subsection{BUG FIXES}{
    \itemize{

      \item Use the session character encoding to determine whether to
      run unicode tests. Tests break in non-unicode sessions otherwise.

    }
  }
}

\section{Changes in version 0.2-0}{
  \subsection{NEW FEATURES}{
    \itemize{

      \item Introduced new functions \code{querySelectorNS()} and
      \code{querySelectorAllNS()} to ease the use of namespaces within a
      document. Previously this would have required knowledge of XPath.

    }
  }
  \subsection{BUG FIXES}{
    \itemize{

      \item Fix meaning of \code{:empty}, whitespace is not empty.

      \item Use \code{lang()} for XML documents with the \code{:lang()}
      CSS selector.

      \item \code{|ident} no longer produces a parsing error, but is now
      equivalent to just 'ident'.

    }
  }
}

\section{Changes in version 0.1-1}{
  \subsection{BUG FIXES}{
    \itemize{

      \item Now testing unicode only in non-Windows platforms on package
      check. Output should still be consistent, just depends on the
      current charset being unicode.

    }
  }
}

\section{Changes in version 0.1-0}{
  \subsection{NEW FEATURES}{
    \itemize{

      \item Initial port of the Python 'cssselect' package. Code is very
      literally ported, including the test suite.

      \item Wrapped translation functionality into a single function,
      \code{css_to_xpath()}.

      \item Created two convenience functions, \code{querySelector()} and
      \code{querySelectorAll()}. These mirror the behaviour of the same
      functions present in a web browser. \code{querySelector()} returns a
      node, while \code{querySelectorAll()} returns a list of nodes.

    }
  }
}
