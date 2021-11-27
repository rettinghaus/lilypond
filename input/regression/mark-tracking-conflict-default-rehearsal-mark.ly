\version "2.23.6"
#(ly:set-option 'warning-as-error #t)

\header {
  texidoc = "LilyPond issues warnings for conflicting simultaneous
marks and engraves only the first -- in this case, 1, 2, 4, 5,
and@tie{}6."
}

\layout {
  \context {
    \Score
    markFormatter = #format-mark-numbers
  }
}

\parallelMusic upper,lower {
  R1 \mark \default |
  R1 \mark "A!"     |
  #(ly:expect-warning (ly:translate-cpp-warning-scheme
                       "conflict with event: `%s'") "rehearsal-mark-event")
  #(ly:expect-warning (ly:translate-cpp-warning-scheme
                       "discarding event: `%s'") "ad-hoc-mark-event")

  R1 \mark \default |
  R1 \mark \default |
  %% no warning

  R1 \mark \default |
  R1 \mark 4        |
  %% no warning

  R1 \mark \default |
  R1 \segnoMark \default |
  #(ly:expect-warning (ly:translate-cpp-warning-scheme
                       "conflict with event: `%s'") "rehearsal-mark-event")
  #(ly:expect-warning (ly:translate-cpp-warning-scheme
                       "discarding event: `%s'") "segno-mark-event")

  R1 \mark \default |
  R1 \segnoMark 2 |
  #(ly:expect-warning (ly:translate-cpp-warning-scheme
                       "conflict with event: `%s'") "rehearsal-mark-event")
  #(ly:expect-warning (ly:translate-cpp-warning-scheme
                       "discarding event: `%s'") "segno-mark-event")

  R1 |
  R1 |
}

\new Staff <<
  \new Voice \upper
  \new Voice \lower
>>