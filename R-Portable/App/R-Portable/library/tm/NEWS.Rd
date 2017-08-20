\name{NEWS}
\title{News for Package 'tm'}
\encoding{UTF-8}
\section{Changes in tm version 0.7-1}{
  \subsection{BUG FIXES}{
    \itemize{
      \item Compilation fixes for Clang's libc++.
    }
  }
}
\section{Changes in tm version 0.7}{
  \subsection{SIGNIFICANT USER-VISIBLE CHANGES}{
    \itemize{
      \item \code{inspect.TermDocumentMatrix()} now displays a sample instead
        of the full matrix. The full dense representation is available via
        \code{as.matrix()}.
    }
  }
  \subsection{NEW FEATURES}{
    \itemize{
      \item \code{SimpleCorpus} provides a corpus which is optimized for the
        most common usage scenario: importing plain texts from files in a
        directory or directly from a vector in \R, preprocessing and transforming
        the texts, and finally exporting them to a term-document matrix. The aim
        is to boost performance and minimize memory pressure. It loads all
        documents into memory, and is designed for medium-sized to large data
        sets.
      \item \code{inspect()} on text documents as a shorthand for
        \code{writeLines(as.character())}.
      \item \code{findMostFreqTerms()} finds most frequent terms in a
        document-term or term-document matrix, or a vector of term frequencies.
      \item \code{tm_parLapply()} is now internally used for the parallelization
        of transformations, filters, and term-document matrix construction. The
        preferred parallelization engine can be registered via
        \code{tm_parLapply_engine()}. The default is to use no parallelization
        (instead of \code{\link[parallel]{mclapply}} (package \pkg{parallel}) in
        previous versions).
    }
  }
}
\section{Changes in tm version 0.6-2}{
  \subsection{BUG FIXES}{
    \itemize{
      \item \code{format.PlainTextDocument()} now reports only one character
        count for a whole document.
    }
  }
}
\section{Changes in tm version 0.6-1}{
  \subsection{SIGNIFICANT USER-VISIBLE CHANGES}{
    \itemize{
      \item \code{format.PlainTextDocument()} now displays a compact
        representation instead of the content. Use \code{as.character()} to
        obtain the character content (which in turn can be applied to a corpus
        via \code{lapply()}).
    }
  }
  \subsection{NEW FEATURES}{
    \itemize{
      \item \code{ZipSource()} for processing ZIP files.
      \item Sources now provide \code{open()} and \code{close()}.
      \item \code{termFreq()} now accepts \code{Span_Tokenizer} and
        \code{Token_Tokenizer} (both from package \pkg{NLP}) objects as
        tokenizers.
      \item \code{readTagged()}, a reader for text documents containing
        POS-tagged words.
    }
  }
  \subsection{BUG FIXES}{
    \itemize{
      \item The function \code{removeWords()} now correctly processes words
        being truncations of others. Reported by Александр Труфанов.
    }
  }
}
\section{Changes in tm version 0.6}{
  \subsection{SIGNIFICANT USER-VISIBLE CHANGES}{
    \itemize{
      \item \code{DirSource()} and \code{URISource()} now use the argument
        \code{encoding} for conversion via \code{iconv()} to \code{"UTF-8"}.
      \item \code{termFreq()} now uses \code{words()} as the default tokenizer.
      \item Text documents now provide the functions \code{content()} and
        \code{as.character()} to access the (possibly raw) document content and
        the natural language text in a suitable (not necessarily structured)
        form.
      \item The internal representation of corpora, sources, and text documents
        changed. Saved objects created with older \pkg{tm} versions are
        incompatible and need to be rebuilt.
    }
  }
  \subsection{NEW FEATURES}{
    \itemize{
      \item \code{DirSource()} and \code{URISource()} now have a \code{mode}
        argument specifying how elements should be read (no read, binary, text).
      \item Improved high-level documentation on corpora (\code{?Corpus}), text
        documents (\code{?TextDocument}), sources (\code{?Source}), and readers
        (\code{?Reader}).
      \item Integration with package \pkg{NLP}.
      \item Romanian stopwords. Suggested by Cristian Chirita.
      \item \code{words.PlainTextDocument()} delivers word tokens in the
        document.
    }
  }
  \subsection{BUG FIXES}{
    \itemize{
      \item The function \code{stemCompletion()} now avoids spurious duplicate
        results. Reported by Seong-Hyeon Kim.
    }
  }
  \subsection{DEPRECATED & DEFUNCT}{
    \itemize{
      \item Following functions have been removed:
      \itemize{
        \item \code{Author()}, \code{DateTimeStamp()}, \code{CMetaData()},
          \code{content_meta()}, \code{DMetaData()}, \code{Description()},
          \code{Heading()}, \code{ID()}, \code{Language()},
          \code{LocalMetaData()}, \code{Origin()}, \code{prescindMeta()},
          \code{sFilter()} (use \code{meta()} instead).
        \item \code{dissimilarity()} (use \code{proxy::dist()} instead).
        \item \code{makeChunks()} (use \code{[} and \code{[[} manually).
        \item \code{summary.Corpus()} and \code{summary.TextRepository()}
          (\code{print()} now gives a more informative but succinct overview).
        \item \code{TextRepository()} and \code{RepoMetaData()} (use e.g. a
          list to store multiple corpora instead).
      }
    }
  }
}
\section{Changes in tm version 0.5-10}{
  \subsection{SIGNIFICANT USER-VISIBLE CHANGES}{
    \itemize{
      \item License changed to GPL-3 (from GPL-2 | GPL-3).
      \item Following functions have been renamed:
      \itemize{
        \item \code{tm_tag_score()} to \code{tm_term_score()}.
       }
    }
  }
  \subsection{DEPRECATED & DEFUNCT}{
    \itemize{
      \item Following functions have been removed:
      \itemize{
        \item \code{Dictionary()} (use a character vector instead; use
          \code{Terms()} to extract terms from a document-term or term-document 
          matrix),
        \item \code{GmaneSource()} (but still available via an example in
          \code{XMLSource()}),
        \item \code{preprocessReut21578XML()} (moved to package
          \pkg{tm.corpus.Reuters21578}),
        \item \code{readGmane()} (but still available via an example in
          \code{readXML()}),
        \item \code{searchFullText()} and \code{tm_intersect()}
        (use \code{grep()} instead).
      }
      \item Following S3 classes are no longer registered as S4 classes:
      \itemize{
        \item \code{VCorpus} and \code{PlainTextDocument}.
      }
    }
  }
}
\section{Changes in tm version 0.5-9}{
  \subsection{SIGNIFICANT USER-VISIBLE CHANGES}{
    \itemize{
      \item Stemming functionality is now provided by the package
      \pkg{SnowballC} replacing packages \pkg{Snowball} and \pkg{RWeka}.
      \item All stopword lists (besides Catalan and SMART) available via
      \code{stopwords()} now come from the Snowball stemmer project.
      \item Transformations, filters, and term-document matrix construction
      now use \code{\link[parallel]{mclapply}} (package \pkg{parallel}).
      Packages \pkg{snow} and \pkg{Rmpi} are no longer used.
    }
  }
  \subsection{DEPRECATED & DEFUNCT}{
    \itemize{
      \item Following functions have been removed:
      \itemize{
        \item \code{tm_startCluster()} and \code{tm_stopCluster()}.
      }
    }
  }
}
\section{Changes in tm version 0.5-8}{
  \subsection{SIGNIFICANT USER-VISIBLE CHANGES}{
    \itemize{
      \item The function \code{termFreq()} now processes the
      \code{tolower} and \code{tokenize} options first. 
    }
  }
  \subsection{NEW FEATURES}{
    \itemize{
      \item Catalan stopwords. Requested by Xavier Fernández i Marín.
    }
  }
  \subsection{BUG FIXES}{
    \itemize{
      \item The function \code{termFreq()} now correctly accepts
      user-provided stopwords. Reported by Bettina Grün.
      \item The function \code{termFreq()} now correctly handles the
      lower bound of the option \code{wordLength}. Reported by Steven
      C. Bagley.
    }
  }
}
\section{Changes in tm version 0.5-7}{
  \subsection{SIGNIFICANT USER-VISIBLE CHANGES}{
    \itemize{
      \item The function \code{termFreq()} provides two new arguments for
            generalized bounds checking of term frequencies and word
            lengths. This replaces the arguments minDocFreq and
            minWordLength.
      \item The function \code{termFreq()} is now sensitive to the order of
            control options.
    }
  }
  \subsection{NEW FEATURES}{
    \itemize{
      \item Weighting schemata for term-document matrices in SMART notation.
      \item Local and global options for term-document matrix
            construction.
      \item SMART stopword list was added.
    }
  }
}
\section{Changes in tm version 0.5-5}{
  \subsection{NEW FEATURES}{
    \itemize{
      \item Access documents in a corpus by names (fallback to IDs if names are
            not set), i.e., allow a string for the corpus operator `[[`.
    }
  }
  \subsection{BUG FIXES}{
    \itemize{
      \item The function \code{findFreqTerms()} now checks bounds on a global level
            (to comply with the manual page) instead per document. Reported
            and fixed by Thomas Zapf-Schramm.
    }
  }
}
\section{Changes in tm version 0.5-4}{
  \subsection{SIGNIFICANT USER-VISIBLE CHANGES}{
    \itemize{
      \item Use IETF language tags for language codes (instead of ISO 639-2).
    }
  }
  \subsection{NEW FEATURES}{
    \itemize{
      \item The function \code{tm_tag_score()} provides functionality to score
            documents based on the number of tags found. This is useful for
            sentiment analysis.
      \item The weighting function for term frequency-inverse document
            frequency \code{weightTfIdf()} has now an option for term
            normalization.
      \item Plotting functions to test for Zipf's and Heaps' law on a
            term-document matrix were added: \code{Zipf_plot()} and
            \code{Heaps_plot()}. Contributed by Kurt Hornik.
    }
  }
}
\section{Changes in tm version 0.5-3}{
  \subsection{NEW FEATURES}{
    \itemize{
      \item The reader function \code{readRCV1asPlain()} was added and combines the
            functionality of \code{readRCV1()} and \code{as.PlainTextDocument()}.
      \item The function \code{stemCompletion()} has a set of new heuristics.
    }
  }
}
\section{Changes in tm version 0.5-2}{
  \subsection{SIGNIFICANT USER-VISIBLE CHANGES}{
    \itemize{
      \item The function \code{termFreq()} which is used for building a
            term-document matrix now uses a whitespace oriented tokenizer
            as default.
    }
  }
  \subsection{NEW FEATURES}{
    \itemize{
      \item A combine method for merging multiple term-document matrices
            was added (\code{c.TermDocumentMatrix()}).
      \item The function \code{termFreq()} has now an option to remove
            punctuation characters.
    }
  }
  \subsection{DEPRECATED & DEFUNCT}{
    \itemize{
      \item Following functions have been removed:
      \itemize{
        \item \code{CSVSource()} (use \code{DataframeSource(read.csv(..., stringsAsFactors = FALSE))} instead), and
        \item \code{TermDocMatrix()} (use \code{DocumentTermMatrix()} instead).
      }
    }
  }
  \subsection{BUG FIXES}{
    \itemize{
      \item \code{removeWords()} no longer skips words at the beginning or the end
            of a line. Reported by Mark Kimpel.
    }
  }
}
\section{Changes in tm version 0.5-1}{
  \subsection{BUG FIXES}{
    \itemize{
      \item \code{preprocessReut21578XML()} no longer generates invalid file names.
    }
  }
}
\section{Changes in tm version 0.5}{
  \subsection{SIGNIFICANT USER-VISIBLE CHANGES}{
    \itemize{
      \item All classes, functions, and generics are reimplemented using
            the S3 class system.
      \item Following functions have been renamed:
      \itemize{
        \item \code{activateCluster()} to \code{tm_startCluster()},
        \item \code{asPlain()} to \code{as.PlainTextDocument()},
        \item \code{deactivateCluster()} to \code{tm_stopCluster()},
        \item \code{tmFilter()} to \code{tm_filter()},
        \item \code{tmIndex()} to \code{tm_index()},
        \item \code{tmIntersect()} to \code{tm_intersect()}, and
        \item \code{tmMap()} to \code{tm_map()}.
       }
       \item Mail handling functionality is factored out to the
            \pkg{tm.plugin.mail} package.
    }
  }
  \subsection{DEPRECATED & DEFUNCT}{
    \itemize{
      \item Following functions have been removed:
      \itemize{
        \item \code{tmTolower()} (use \code{tolower()} instead), and
        \item \code{replacePatterns()} (use \code{gsub()} instead).
      }
    }
  }
}
\section{Changes in tm version 0.4}{
  \subsection{SIGNIFICANT USER-VISIBLE CHANGES}{
    \itemize{
      \item The Corpus class is now virtual providing an abstract
            interface.
      \item VCorpus, the default implementation of the abstract corpus
            interface (by subclassing), provides a corpus with volatile (=
            standard \R object) semantics. It loads all documents into
            memory, and is designed for small to medium-sized data sets.
      \item PCorpus, an implementation of the abstract corpus interface (by
            subclassing), provides a corpus with permanent storage
            semantics. The actual data is stored in an external database
            (file) object (as supported by the \pkg{filehash} package), with
            automatic (un-)loading into memory. It is designed for systems
            with small memory.
      \item Language codes are now in ISO 639-2 (instead of ISO 639-1).
      \item Reader functions no longer have a load argument for lazy
            loading.
    }
  }
  \subsection{NEW FEATURES}{
    \itemize{
      \item The reader function \code{readReut21578XMLasPlain()} was added and
            combines the functionality of \code{readReut21578XML()} and \code{asPlain()}.
    }
  }
  \subsection{BUG FIXES}{
    \itemize{
      \item \code{weightTfIdf()} no longer applies a binary weighting to an input
            matrix in term frequency format (which happened only in 0.3-4).
    }
  }
}
\section{Changes in tm version 0.3-4}{
  \subsection{SIGNIFICANT USER-VISIBLE CHANGES}{
    \itemize{
      \item \code{.onLoad()} no longer tries to start a MPI cluster (which often
            failed in misconfigured environments). Use \code{activateCluster()}
            and \code{deactivateCluster()} instead.
      \item DocumentTermMatrix (the improved reimplementation of defunct
            TermDocMatrix) does not use the \pkg{Matrix} package anymore.
    }
  }
  \subsection{NEW FEATURES}{
    \itemize{
      \item The \code{DirSource()} constructor now accepts the two new (optional)
            arguments pattern and ignore.case. With pattern one can define
            a regular expression for selecting only matching files, and
            ignore.case specifies whether pattern-matching is
            case-sensitive.
      \item The \code{readNewsgroup()} reader function can now be configured for
            custom date formats (via the DateFormat argument).
      \item The \code{readPDF()} reader function can now be configured (via the
            PdfinfoOptions and PdftotextOptions arguments).
      \item The \code{readDOC()} reader function can now be configured (via the
            AntiwordOptions argument).
      \item Sources now can be vectorized. This allows faster corpus
            construction.
      \item New XMLSource class for arbitrary XML files.
      \item The new \code{readTabular()} reader function allows to create a custom
            tailor-made reader configured via mappings from a tabular data
            structure.
      \item The new \code{readXML()} reader function allows to read in arbitrary
            XML files which are described with a specification.
      \item The new \code{tmReduce()} transformation allows to combine multiple
            maps into one transformation.
    }
  }
  \subsection{DEPRECATED & DEFUNCT}{
    \itemize{
      \item CSVSource is defunct (use DataframeSource instead).
      \item weightLogical is defunct.
      \item TermDocMatrix is defunct (use DocumentTermMatrix or
            TermDocumentMatrix instead).
    }
  }
}
\section{Changes in tm version 0.3-3}{
  \subsection{NEW FEATURES}{
    \itemize{
      \item The abstract Source class gets a default implementation for
            the \code{stepNext()} method. It increments the position counter by
            one, a reasonable value for most sources. For special purposes
            custom methods can be created via overloading \code{stepNext()} of
            the subclass.
      \item New URISource class for a single document identified by a
            Uniform Resource Identifier.
      \item New DataframeSource for documents stored in a data frame. Each
            row is interpreted as a single document.
    }
  }
  \subsection{BUG FIXES}{
    \itemize{
      \item Fix off-by-one error in \code{convertMboxEml()} function. Reported by
            Angela Bohn.
      \item Sort row indices in sparse term-document matrices. Kudos to
            Martin Mächler for his suggestions.
      \item Sources and readers no longer evaluate calls in a non-standard
            way.
    }
  }
}
\section{Changes in tm version 0.3-2}{
  \subsection{NEW FEATURES}{
    \itemize{
      \item Weighting functions now have an Acronym slot containing
            abbreviations of the weighting functions' names. This is highly
            useful when generating tables with indications which weighting
            scheme was actually used for your experiments.
      \item The functions \code{tmFilter()}, \code{tmIndex()}, \code{tmMap()} and \code{TermDocMatrix()}
            now can use a MPI cluster (via the \pkg{snow} and \pkg{Rmpi} packages) if
            available. Use \code{(de)activateCluster()} to manually override
            cluster usage settings. Special thanks to Stefan Theussl for
            his constructive comments.
      \item The Source class receives a new Length slot. It contains the
            number of elements provided by the source (although there
            might be rare cases where the number cannot be determined in
            advance---then it should be set to zero).
    }
  }
}
