\version "2.25.24"

\header {
  texidoc = "@code{\\overrideTimeSignatureSettings} can set beaming properties
to use when @code{timeSignatureFraction} is @code{#f}.  The output should have
no time signature or bar lines.  The first six notes should be grouped
@code{1,2,3}, and that grouping should repeat thrice."
}

#(ly:set-option 'warning-as-error #t)

\new Score \with {
  forbidBreakBetweenBarLines = ##f
  \overrideTimeSignatureSettings
    ##f       % timeSignatureFraction
    #1/8      % beatBase
    1,2,3     % beatStructure
    #'()      % beamExceptions
  timeSignatureFraction = ##f
} {
  \repeat unfold 18 c'8
}
