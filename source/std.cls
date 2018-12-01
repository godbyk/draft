%
% Document design for C++ standard
%

\NeedsTeXFormat{LaTeX2e}[1994/06/01]

\RequirePackage{expl3}
\RequirePackage{xparse}

\ProvidesClass{std}[2018/11/30 v1.0.0 C++ standard document design]

%
% Pass any class options to the underlying memoir class
%
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{memoir}}

\ProcessOptions

\PassOptionsToClass{a4paper,10pt,oneside,openany,final}{memoir}

\LoadClass{memoir}

\ExplSyntaxOn
\bool_new:N \g_std_draft_bool
\tl_new:N \g_std_editor_name_tl
\tl_new:N \g_std_editor_organization_tl
\tl_new:N \g_std_editor_email_tl
\tl_new:N \g_std_document_number_tl
\tl_new:N \g_std_previous_document_number_tl
\tl_new:N \g_std_cpp_version_tl
\tl_new:N \g_std_release_date_tl
\tl_new:N \g_std_first_library_chapter_tl
\tl_new:N \g_std_last_library_chapter_tl

\keys_define:nn { std / metadata } {
  draft                    .bool_set:N = \g_std_draft_bool,
  editor                   .tl_set:N = \g_std_editor_name_tl,
  editor-organization      .tl_set:N = \g_std_editor_organization_tl,
  editor-email             .tl_set:N = \g_std_editor_email_tl,
  document-number          .tl_set:N = \g_std_document_number_tl,
  previous-document-number .tl_set:N = \g_std_previous_document_number_tl,
  cpp-version              .tl_set:N = \g_std_cpp_version_tl,
  release-date             .tl_set:N = \g_std_release_date_tl,
  first-library-chapter    .tl_set:N = \g_std_first_library_chapter_tl,
  last-library-chapter     .tl_set:N = \g_std_last_library_chapter_tl,
}

\NewDocumentCommand \stdsetup { m } {
  \keys_set:nn { std / metadata } { #1 }
}

\NewDocumentCommand \firstlibchapter { } { \tl_use:N \g_std_first_library_chapter_tl }
\NewDocumentCommand \lastlibchapter { } { \tl_use:N \g_std_last_library_chapter_tl }
\NewDocumentCommand \cppver { } { \tl_use:N \g_std_cpp_version_tl }
\NewDocumentCommand \reldate { } { \tl_use:N \g_std_release_date_tl }
\ExplSyntaxOff

\RequirePackage[american]{babel}        % needed for iso dates
\RequirePackage[iso,american]{isodate}      % use iso format for dates
\RequirePackage[final]{listings}     % code listings
\RequirePackage{longtable}    % auto-breaking tables
\RequirePackage{ltcaption}    % fix captions for long tables
\RequirePackage{relsize}      % provide relative font size changes
\RequirePackage{textcomp}     % provide \text{l,r}angle
\RequirePackage{underscore}   % remove special status of '_' in ordinary text
\RequirePackage{parskip}      % handle non-indented paragraphs "properly"
\RequirePackage{array}        % new column definitions for tables
\RequirePackage[normalem]{ulem}
\RequirePackage{enumitem}
\RequirePackage{color}        % define colors for strikeouts and underlines
\RequirePackage{amsmath}      % additional math symbols
\RequirePackage{mathrsfs}     % mathscr font
\RequirePackage[final]{microtype}
\RequirePackage{multicol}
\RequirePackage{lmodern}
\RequirePackage[T1]{fontenc}
\RequirePackage[pdftex, final]{graphicx}
\RequirePackage[pdftex,
                pdftitle={C++ International Standard},
                pdfsubject={C++ International Standard},
                pdfcreator={Richard Smith},
                bookmarks=true,
                bookmarksnumbered=true,
                pdfpagelabels=true,
                pdfpagemode=UseOutlines,
                pdfstartview=FitH,
                linktocpage=true,
                colorlinks=true,
                linkcolor=blue,
                plainpages=false
               ]{hyperref}
\RequirePackage{memhfixc}     % fix interactions between hyperref and memoir
\RequirePackage[active,header=false,handles=false,copydocumentclass=false,generate=std-gram.ext,extract-cmdline={gramSec},extract-env={bnf,simplebnf}]{extract} % Grammar extraction

\pdfminorversion=5
\pdfcompresslevel=9
\pdfobjcompresslevel=2

\renewcommand\RSsmallest{5.5pt}  % smallest font size for relsize

%% layout -- set overall page appearance

%%--------------------------------------------------
%%  set page size, type block size, type block position

\setlrmarginsandblock{2.245cm}{2.245cm}{*}
\setulmarginsandblock{2.5cm}{2.5cm}{*}

%%--------------------------------------------------
%%  set header and footer positions and sizes

\setheadfoot{\onelineskip}{2\onelineskip}
\setheaderspaces{*}{2\onelineskip}{*}

%%--------------------------------------------------
%%  make miscellaneous adjustments, then finish the layout
\setmarginnotes{7pt}{7pt}{0pt}
\checkandfixthelayout

%%--------------------------------------------------
%% If there is insufficient stretchable vertical space on a page,
%% TeX will not properly consider penalties for a good page break,
%% even if \raggedbottom (default) is in effect.
\addtolength{\topskip}{0pt plus 20pt}

%%--------------------------------------------------
%% Place footnotes at the bottom of the page, rather
%% than immediately following the main text.
\feetatbottom

%%--------------------------------------------------
%% Paragraph and bullet numbering

\newcounter{Paras}
\counterwithin{Paras}{chapter}
\counterwithin{Paras}{section}
\counterwithin{Paras}{subsection}
\counterwithin{Paras}{subsubsection}
\counterwithin{Paras}{paragraph}
\counterwithin{Paras}{subparagraph}

\newcounter{Bullets1}[Paras]
\newcounter{Bullets2}[Bullets1]
\newcounter{Bullets3}[Bullets2]
\newcounter{Bullets4}[Bullets3]

\makeatletter
\newcommand{\parabullnum}[2]{%
\stepcounter{#1}%
\noindent\makebox[0pt][l]{\makebox[#2][r]{%
\scriptsize\raisebox{.7ex}%
{%
\ifnum \value{Paras}>0
\ifnum \value{Bullets1}>0 (\fi%
                          \arabic{Paras}%
\ifnum \value{Bullets1}>0 .\arabic{Bullets1}%
\ifnum \value{Bullets2}>0 .\arabic{Bullets2}%
\ifnum \value{Bullets3}>0 .\arabic{Bullets3}%
\fi\fi\fi%
\ifnum \value{Bullets1}>0 )\fi%
\fi%
}%
\hspace{\@totalleftmargin}\quad%
}}}
\makeatother

\def\pnum{\parabullnum{Paras}{0pt}}

% Leave more room for section numbers in TOC
\cftsetindents{section}{1.5em}{3.0em}


%% styles -- set styles for:
%     chapters
%     pages
%     footnotes

%%--------------------------------------------------
%%  create chapter style

\makechapterstyle{cppstd}{%
  \renewcommand{\beforechapskip}{\onelineskip}
  \renewcommand{\afterchapskip}{\onelineskip}
  %\renewcommand{\chapternamenum}{}
  \renewcommand{\chapnamefont}{\chaptitlefont}
  \renewcommand{\chapnumfont}{\chaptitlefont}
  \renewcommand{\printchapternum}{\chapnumfont\thechapter\quad}
  \renewcommand{\afterchapternum}{}
}

%%--------------------------------------------------
%%  create page styles

\makepagestyle{cpppage}
\ExplSyntaxOn
\makeevenhead{cpppage}{\copyright\,\textsc{ISO/IEC}}{}{\textbf{\tl_use:N \g_std_document_number_tl}}
\makeoddhead{cpppage}{\copyright\,\textsc{ISO/IEC}}{}{\textbf{\tl_use:N \g_std_document_number_tl}}
\ExplSyntaxOff
\makeevenfoot{cpppage}{\leftmark}{}{\thepage}
\makeoddfoot{cpppage}{\leftmark}{}{\thepage}

\makeatletter
\makepsmarks{cpppage}{%
  \let\@mkboth\markboth
  \def\chaptermark##1{\markboth{##1}{##1}}%
  \def\sectionmark##1{\markboth{%
    \ifnum \c@secnumdepth>\z@
      \textsection\space\thesection
    \fi
    }{\rightmark}}%
  \def\subsectionmark##1{\markboth{%
    \ifnum \c@secnumdepth>\z@
      \textsection\space\thesubsection
    \fi
    }{\rightmark}}%
  \def\subsubsectionmark##1{\markboth{%
    \ifnum \c@secnumdepth>\z@
      \textsection\space\thesubsubsection
    \fi
    }{\rightmark}}%
  \def\paragraphmark##1{\markboth{%
    \ifnum \c@secnumdepth>\z@
      \textsection\space\theparagraph
    \fi
    }{\rightmark}}}
\makeatother

\aliaspagestyle{chapter}{cpppage}

%%--------------------------------------------------
%%  set heading styles for main matter
\newcommand{\beforeskip}{-.7\onelineskip plus -1ex}
\newcommand{\afterskip}{.3\onelineskip minus .2ex}

\setbeforesecskip{\beforeskip}
\setsecindent{0pt}
\setsecheadstyle{\large\bfseries\raggedright}
\setaftersecskip{\afterskip}

\setbeforesubsecskip{\beforeskip}
\setsubsecindent{0pt}
\setsubsecheadstyle{\large\bfseries\raggedright}
\setaftersubsecskip{\afterskip}

\setbeforesubsubsecskip{\beforeskip}
\setsubsubsecindent{0pt}
\setsubsubsecheadstyle{\normalsize\bfseries\raggedright}
\setaftersubsubsecskip{\afterskip}

\setbeforeparaskip{\beforeskip}
\setparaindent{0pt}
\setparaheadstyle{\normalsize\bfseries\raggedright}
\setafterparaskip{\afterskip}

\setbeforesubparaskip{\beforeskip}
\setsubparaindent{0pt}
\setsubparaheadstyle{\normalsize\bfseries\raggedright}
\setaftersubparaskip{\afterskip}

%%--------------------------------------------------
% set heading style for annexes
\newcommand{\Annex}[3]{\chapter[#2]{(#3)\protect\\#2\hfill[#1]}\relax\annexlabel{#1}}
\newcommand{\infannex}[2]{\Annex{#1}{#2}{informative}\addxref{#1}}
\newcommand{\normannex}[2]{\Annex{#1}{#2}{normative}\addxref{#1}}

%%--------------------------------------------------
%%  set footnote style
\footmarkstyle{\smaller#1) }

%%--------------------------------------------------
% set style for main text
\setlength{\parindent}{0pt}
\setlength{\parskip}{1ex}

% set style for lists (itemizations, enumerations)
\setlength{\partopsep}{0pt}
\newlist{indenthelper}{itemize}{1}
\newlist{bnflist}{itemize}{1}
\setlist[itemize]{parsep=\parskip, partopsep=0pt, itemsep=0pt, topsep=0pt,
                  beginpenalty=10 }
\setlist[enumerate]{parsep=\parskip, partopsep=0pt, itemsep=0pt, topsep=0pt}
\setlist[indenthelper]{parsep=\parskip, partopsep=0pt, itemsep=0pt, topsep=0pt, label={}}
\setlist[bnflist]{parsep=\parskip, partopsep=0pt, itemsep=0pt, topsep=0pt, label={},
                  leftmargin=\bnfindentrest, listparindent=-\bnfindentinc, itemindent=\listparindent}

%%--------------------------------------------------
%%  set caption style and delimiter
\captionstyle{\centering}
\captiondelim{ --- }
% override longtable's caption delimiter to match
\makeatletter
\def\LT@makecaption#1#2#3{%
  \LT@mcol\LT@cols c{\hbox to\z@{\hss\parbox[t]\LTcapwidth{%
    \sbox\@tempboxa{#1{#2 --- }#3}%
    \ifdim\wd\@tempboxa>\hsize
      #1{#2 --- }#3%
    \else
      \hbox to\hsize{\hfil\box\@tempboxa\hfil}%
    \fi
    \endgraf\vskip\baselineskip}%
  \hss}}}
\makeatother

%%--------------------------------------------------
%% set global styles that get reset by \mainmatter
\makeatletter
\renewcommand{\mainmatter}{%
  \@ifstar{\@smemmain}{\@memmain}%
  \counterwithout{footnote}{chapter}%
  \counterwithout{table}{chapter}%
  \counterwithout{figure}{chapter}%
  \renewcommand{\chaptername}{}%
  \renewcommand{\appendixname}{Annex}%
}
\makeatother

%%--------------------------------------------------
%% change list item markers to number and em-dash

\renewcommand{\labelitemi}{---\parabullnum{Bullets1}{\labelsep}}
\renewcommand{\labelitemii}{---\parabullnum{Bullets2}{\labelsep}}
\renewcommand{\labelitemiii}{---\parabullnum{Bullets3}{\labelsep}}
\renewcommand{\labelitemiv}{---\parabullnum{Bullets4}{\labelsep}}

%%--------------------------------------------------
%% set section numbering limit, toc limit
\maxsecnumdepth{subparagraph}
\setcounter{tocdepth}{1}

%%--------------------------------------------------
%% override some functions from the listings package to avoid bad page breaks
%% (copied verbatim from listings.sty version 1.6 except where commented)
\makeatletter

\lst@CheckVersion{1.7}{\lst@CheckVersion{1.6}{\lst@CheckVersion{1.5b}{
 \typeout{^^J%
 ***^^J%
 *** This file requires listings.sty version 1.6.^^J%
 *** You have version \lst@version; exiting ...^^J%
 ***^^J}%
 \batchmode \@@end}}}

\def\lst@Init#1{%
    \begingroup
    \ifx\lst@float\relax\else
        \edef\@tempa{\noexpand\lst@beginfloat{lstlisting}[\lst@float]}%
        \expandafter\@tempa
    \fi
    \ifx\lst@multicols\@empty\else
        \edef\lst@next{\noexpand\multicols{\lst@multicols}}
        \expandafter\lst@next
    \fi
    \ifhmode\ifinner \lst@boxtrue \fi\fi
    \lst@ifbox
        \lsthk@BoxUnsafe
        \hbox to\z@\bgroup
             $\if t\lst@boxpos \vtop
        \else \if b\lst@boxpos \vbox
        \else \vcenter \fi\fi
        \bgroup \par\noindent
    \else
        \lst@ifdisplaystyle
            \lst@EveryDisplay
            % make penalty configurable
            \par\lst@beginpenalty
            \vspace\lst@aboveskip
        \fi
    \fi
    \normalbaselines
    \abovecaptionskip\lst@abovecaption\relax
    \belowcaptionskip\lst@belowcaption\relax
    \lst@MakeCaption t%
    \lsthk@PreInit \lsthk@Init
    \lst@ifdisplaystyle
        \global\let\lst@ltxlabel\@empty
        \if@inlabel
            \lst@ifresetmargins
                \leavevmode
            \else
                \xdef\lst@ltxlabel{\the\everypar}%
                \lst@AddTo\lst@ltxlabel{%
                    \global\let\lst@ltxlabel\@empty
                    \everypar{\lsthk@EveryLine\lsthk@EveryPar}}%
            \fi
        \fi
        % A section heading might have set \everypar to apply a \clubpenalty
        % to the following paragraph, changing \everypar in the process.
        % Unconditionally overriding \everypar is a bad idea.
        % \everypar\expandafter{\lst@ltxlabel
        %                      \lsthk@EveryLine\lsthk@EveryPar}%
    \else
        \everypar{}\let\lst@NewLine\@empty
    \fi
    \lsthk@InitVars \lsthk@InitVarsBOL
    \lst@Let{13}\lst@MProcessListing
    \let\lst@Backslash#1%
    \lst@EnterMode{\lst@Pmode}{\lst@SelectCharTable}%
    \lst@InitFinalize}

\def\lst@DeInit{%
    \lst@XPrintToken \lst@EOLUpdate
    \global\advance\lst@newlines\m@ne
    \lst@ifshowlines
        \lst@DoNewLines
    \else
        \setbox\@tempboxa\vbox{\lst@DoNewLines}%
    \fi
    \lst@ifdisplaystyle \par\removelastskip \fi
    \lsthk@ExitVars\everypar{}\lsthk@DeInit\normalbaselines\normalcolor
    \lst@MakeCaption b%
    \lst@ifbox
        \egroup $\hss \egroup
        \vrule\@width\lst@maxwidth\@height\z@\@depth\z@
    \else
        \lst@ifdisplaystyle
            % make penalty configurable
            \par\lst@endpenalty
            \vspace\lst@belowskip
        \fi
    \fi
    \ifx\lst@multicols\@empty\else
        \def\lst@next{\global\let\@checkend\@gobble
                      \endmulticols
                      \global\let\@checkend\lst@@checkend}
        \expandafter\lst@next
    \fi
    \ifx\lst@float\relax\else
        \expandafter\lst@endfloat
    \fi
    \endgroup}


\def\lst@NewLine{%
    \ifx\lst@OutputBox\@gobble\else
        \par
        % add configurable penalties
        \lst@ifeolsemicolon
          \lst@semicolonpenalty
          \lst@eolsemicolonfalse
        \else
          \lst@domidpenalty
        \fi
        % Manually apply EveryLine and EveryPar; do not depend on \everypar
        \noindent \hbox{}\lsthk@EveryLine%
        % \lsthk@EveryPar uses \refstepcounter which balloons the PDF
    \fi
    \global\advance\lst@newlines\m@ne
    \lst@newlinetrue}

% new macro for empty lines, avoiding an \hbox that cannot be discarded
\def\lst@DoEmptyLine{%
  \ifvmode\else\par\fi\lst@emptylinepenalty
  \vskip\parskip
  \vskip\baselineskip
  % \lsthk@EveryLine has \lst@parshape, i.e. \parshape, which causes an \hbox
  % \lsthk@EveryPar increments line counters; \refstepcounter balloons the PDF
  \global\advance\lst@newlines\m@ne
  \lst@newlinetrue}

\def\lst@DoNewLines{
    \@whilenum\lst@newlines>\lst@maxempty \do
        {\lst@ifpreservenumber
            \lsthk@OnEmptyLine
            \global\advance\c@lstnumber\lst@advancelstnum
         \fi
         \global\advance\lst@newlines\m@ne}%
    \@whilenum \lst@newlines>\@ne \do
        % special-case empty printing of lines
        {\lsthk@OnEmptyLine\lst@DoEmptyLine}%
    \ifnum\lst@newlines>\z@ \lst@NewLine \fi}

% add keys for configuring before/end vertical penalties
\lst@Key{beginpenalty}\relax{\def\lst@beginpenalty{\penalty #1}}
\let\lst@beginpenalty\@empty
\lst@Key{midpenalty}\relax{\def\lst@midpenalty{\penalty #1}}
\let\lst@midpenalty\@empty
\lst@Key{endpenalty}\relax{\def\lst@endpenalty{\penalty #1}}
\let\lst@endpenalty\@empty
\lst@Key{emptylinepenalty}\relax{\def\lst@emptylinepenalty{\penalty #1}}
\let\lst@emptylinepenalty\@empty
\lst@Key{semicolonpenalty}\relax{\def\lst@semicolonpenalty{\penalty #1}}
\let\lst@semicolonpenalty\@empty

\lst@AddToHook{InitVars}{\let\lst@domidpenalty\@empty}
\lst@AddToHook{InitVarsEOL}{\let\lst@domidpenalty\lst@midpenalty}

% handle semicolons and closing braces (could be in \lstdefinelanguage as well)
\def\lst@eolsemicolontrue{\global\let\lst@ifeolsemicolon\iftrue}
\def\lst@eolsemicolonfalse{\global\let\lst@ifeolsemicolon\iffalse}
\lst@AddToHook{InitVars}{
  \global\let\lst@eolsemicolonpending\@empty
  \lst@eolsemicolonfalse
}
% If we found a semicolon or closing brace while parsing the current line,
% inform the subsequent \lst@NewLine about it for penalties.
\lst@AddToHook{InitVarsEOL}{%
  \ifx\lst@eolsemicolonpending\relax
    \lst@eolsemicolontrue
    \global\let\lst@eolsemicolonpending\@empty
  \fi%
}
\lst@AddToHook{SelectCharTable}{%
  % In theory, we should only detect trailing semicolons or braces,
  % but that would require un-doing the marking for any other character.
  % The next best thing is to undo the marking for closing parentheses,
  % because loops or if statements are the only places where we will
  % reasonably have a semicolon in the middle of a line, and those all
  % end with a closing parenthesis.
  \lst@DefSaveDef{41}\lstsaved@closeparen{%    handle closing parenthesis
    \lstsaved@closeparen
    \ifnum\lst@mode=\lst@Pmode    % regular processing mode (not a comment)
      \global\let\lst@eolsemicolonpending\@empty  % undo semicolon setting
    \fi%
  }%
  \lst@DefSaveDef{59}\lstsaved@semicolon{%     handle semicolon
    \lstsaved@semicolon
    \ifnum\lst@mode=\lst@Pmode    % regular processing mode (not a comment)
      \global\let\lst@eolsemicolonpending\relax
    \fi%
  }%
  \lst@DefSaveDef{125}\lstsaved@closebrace{%   handle closing brace
    \lst@eolsemicolonfalse        % do not break before a closing brace
    \lstsaved@closebrace          % might invoke \lst@NewLine
    \ifnum\lst@mode=\lst@Pmode    % regular processing mode (not a comment)
      \global\let\lst@eolsemicolonpending\relax
    \fi%
  }%
}

\makeatother



% Definitions and redefinitions of special commands

%%--------------------------------------------------
%% Difference markups
\definecolor{addclr}{rgb}{0,.6,.6}
\definecolor{remclr}{rgb}{1,0,0}
\definecolor{noteclr}{rgb}{0,0,1}

\renewcommand{\added}[1]{\textcolor{addclr}{\uline{#1}}}
\newcommand{\removed}[1]{\textcolor{remclr}{\sout{#1}}}
\renewcommand{\changed}[2]{\removed{#1}\added{#2}}

\newcommand{\nbc}[1]{[#1]\ }
\newcommand{\addednb}[2]{\added{\nbc{#1}#2}}
\newcommand{\removednb}[2]{\removed{\nbc{#1}#2}}
\newcommand{\changednb}[3]{\removednb{#1}{#2}\added{#3}}
\newcommand{\remitem}[1]{\item\removed{#1}}

\newcommand{\ednote}[1]{\textcolor{noteclr}{[Editor's note: #1] }}
% \newcommand{\ednote}[1]{}

\newenvironment{addedblock}
{
\color{addclr}
}
{
\color{black}
}
\newenvironment{removedblock}
{
\color{remclr}
}
{
\color{black}
}

%%--------------------------------------------------
%% Grammar extraction.
\def\gramSec[#1]#2{}

\makeatletter
\newcommand{\FlushAndPrintGrammar}{%
\immediate\closeout\XTR@out%
\immediate\openout\XTR@out=std-gram-dummy.tmp%
\def\gramSec[##1]##2{\rSec1[##1]{##2}}%
\input{std-gram.ext}%
}
\makeatother

%%--------------------------------------------------
% Escaping for index entries. Replaces ! with "! throughout its argument.
\def\indexescape#1{\doindexescape#1\stopindexescape!\doneindexescape}
\def\doindexescape#1!{#1"!\doindexescape}
\def\stopindexescape#1\doneindexescape{}

%%--------------------------------------------------
%% Cross references.
\newcommand{\addxref}[1]{%
 \glossary[xrefindex]{\indexescape{#1}}{(\ref{\indexescape{#1}})}%
}

%%--------------------------------------------------
%% Sectioning macros.
% Each section has a depth, an automatically generated section
% number, a name, and a short tag.  The depth is an integer in
% the range [0,5].  (If it proves necessary, it wouldn't take much
% programming to raise the limit from 5 to something larger.)

% Set the xref label for a clause to be "Clause n", not just "n".
\makeatletter
\newcommand{\customlabel}[2]{%
\protected@write \@auxout {}{\string \newlabel {#1}{{#2}{\thepage}{#2}{#1}{}} }%
\hypertarget{#1}{}%
}
\makeatother
\newcommand{\clauselabel}[1]{\customlabel{#1}{Clause \thechapter}}
\newcommand{\annexlabel}[1]{\customlabel{#1}{Annex \thechapter}}

% The basic sectioning command.  Example:
%    \Sec1[intro.scope]{Scope}
% defines a first-level section whose name is "Scope" and whose short
% tag is intro.scope.  The square brackets are mandatory.
\def\Sec#1[#2]#3{%
\ifcase#1\let\s=\chapter\let\l=\clauselabel
      \or\let\s=\section\let\l=\label
      \or\let\s=\subsection\let\l=\label
      \or\let\s=\subsubsection\let\l=\label
      \or\let\s=\paragraph\let\l=\label
      \or\let\s=\subparagraph\let\l=\label
      \fi%
\s[#3]{#3\hfill[#2]}\l{#2}\addxref{#2}}

% A convenience feature (mostly for the convenience of the Project
% Editor, to make it easy to move around large blocks of text):
% the \rSec macro is just like the \Sec macro, except that depths
% relative to a global variable, SectionDepthBase.  So, for example,
% if SectionDepthBase is 1,
%   \rSec1[temp.arg.type]{Template type arguments}
% is equivalent to
%   \Sec2[temp.arg.type]{Template type arguments}
\newcounter{SectionDepthBase}
\newcounter{SectionDepth}

\def\rSec#1[#2]#3{%
\setcounter{SectionDepth}{#1}
\addtocounter{SectionDepth}{\value{SectionDepthBase}}
\Sec{\arabic{SectionDepth}}[#2]{#3}}

%%--------------------------------------------------
% Indexing

% locations
\newcommand{\indextext}[1]{\index[generalindex]{#1}}
\newcommand{\indexlibrary}[1]{\index[libraryindex]{#1}}
\newcommand{\indexhdr}[1]{\indextext{\idxhdr{#1}}\index[headerindex]{\idxhdr{#1}}}
\newcommand{\indexgram}[1]{\index[grammarindex]{#1}}

% Collation helper: When building an index key, replace all macro definitions
% in the key argument with a no-op for purposes of collation.
\newcommand{\nocode}[1]{#1}
\newcommand{\idxmname}[1]{\_\_#1\_\_}
\newcommand{\idxCpp}{C++}

% \indeximpldef synthesizes a collation key from the argument; that is, an
% invocation \indeximpldef{arg} emits an index entry `key@arg`, where `key`
% is derived from `arg` by replacing the folowing list of commands with their
% bare content. This allows, say, collating plain text and code.
\newcommand{\indeximpldef}[1]{%
\let\otextup\textup%
\let\textup\nocode%
\let\otcode\tcode%
\let\tcode\nocode%
\let\ogrammarterm\grammarterm%
\let\grammarterm\nocode%
\let\omname\mname%
\let\mname\idxmname%
\let\oCpp\Cpp%
\let\Cpp\idxCpp%
\let\oBreakableUnderscore\BreakableUnderscore%  See the "underscore" package.
\let\BreakableUnderscore\textunderscore%
\edef\x{#1}%
\let\tcode\otcode%
\let\grammarterm\gterm%
\let\mname\omname%
\let\Cpp\oCpp%
\let\BreakableUnderscore\oBreakableUnderscore%
\index[impldefindex]{\x@#1}%
\let\grammarterm\ogrammarterm%
\let\textup\otextup%
}

\newcommand{\indexdefn}[1]{\indextext{#1}}
\newcommand{\idxbfpage}[1]{\textbf{\hyperpage{#1}}}
\newcommand{\indexgrammar}[1]{\indextext{#1}\indexgram{#1|idxbfpage}}
% This command uses the "cooked" \indeximpldef command to emit index
% entries; thus they only work for simple index entries that do not contain
% special indexing instructions.
\newcommand{\impldef}[1]{\indeximpldef{#1}implementation-defined}
% \impldefplain passes the argument directly to the index, allowing you to
% use special indexing instructions (!, @, |).
\newcommand{\impldefplain}[1]{\index[impldefindex]{#1}implementation-defined}

% appearance
\newcommand{\idxcode}[1]{#1@\tcode{#1}}
\newcommand{\idxhdr}[1]{#1@\tcode{<#1>}}
\newcommand{\idxgram}[1]{#1@\gterm{#1}}
\newcommand{\idxxname}[1]{__#1@\xname{#1}}

% class member library index
\newcommand{\indexlibrarymember}[2]{\indexlibrary{\idxcode{#1}!\idxcode{#2}}\indexlibrary{\idxcode{#2}!\idxcode{#1}}}

%%--------------------------------------------------
% General code style
\newcommand{\CodeStyle}{\ttfamily}
\newcommand{\CodeStylex}[1]{\texttt{#1}}

% General grammar style
\newcommand{\GrammarStyle}{\itfamily}
\newcommand{\GrammarStylex}[1]{\textit{#1}}

% Code and definitions embedded in text.
\newcommand{\tcode}[1]{\CodeStylex{#1}}
\newcommand{\term}[1]{\textit{#1}}
\newcommand{\gterm}[1]{\GrammarStylex{#1}}
\newcommand{\fakegrammarterm}[1]{\gterm{#1}}
\newcommand{\grammarterm}[1]{\indexgram{\idxgram{#1}}\gterm{#1}}
\newcommand{\grammartermnc}[1]{\indexgram{\idxgram{#1}}\gterm{#1\nocorr}}
\newcommand{\placeholder}[1]{\textit{#1}}
\newcommand{\placeholdernc}[1]{\textit{#1\nocorr}}
\newcommand{\defnxname}[1]{\indextext{\idxxname{#1}}\xname{#1}}
\newcommand{\defnlibxname}[1]{\indexlibrary{\idxxname{#1}}\xname{#1}}

% Non-compound defined term.
\newcommand{\defn}[1]{\defnx{#1}{#1}}
% Defined term with different index entry.
\newcommand{\defnx}[2]{\indexdefn{#2}\textit{#1}}
% Compound defined term with 'see' for primary term.
% Usage: \defnadj{trivial}{class}
\newcommand{\defnadj}[2]{\indextext{#1 #2|see{#2, #1}}\indexdefn{#2!#1}\textit{#1 #2}}

%%--------------------------------------------------
%% allow line break if needed for justification
\newcommand{\brk}{\discretionary{}{}{}}

%%--------------------------------------------------
%% Macros for funky text
\newcommand{\Cpp}{\texorpdfstring{C\kern-0.05em\protect\raisebox{.35ex}{\textsmaller[2]{+\kern-0.05em+}}}{C++}}
\newcommand{\CppIII}{\Cpp{} 2003}
\newcommand{\CppXI}{\Cpp{} 2011}
\newcommand{\CppXIV}{\Cpp{} 2014}
\newcommand{\CppXVII}{\Cpp{} 2017}
\newcommand{\opt}[1]{#1\ensuremath{_\mathit{opt}}}
\newcommand{\dcr}{-{-}}
\newcommand{\bigoh}[1]{\ensuremath{\mathscr{O}(#1)}}

% Make all tildes a little larger to avoid visual similarity with hyphens.
\renewcommand{\~}{\textasciitilde}
\let\OldTextAsciiTilde\textasciitilde
\renewcommand{\textasciitilde}{\protect\raisebox{-0.17ex}{\larger\OldTextAsciiTilde}}
\newcommand{\caret}{\char`\^}

%%--------------------------------------------------
%% States and operators
\newcommand{\state}[2]{\tcode{#1}\ensuremath{_{#2}}}
\newcommand{\bitand}{\ensuremath{\mathbin{\mathsf{bitand}}}}
\newcommand{\bitor}{\ensuremath{\mathbin{\mathsf{bitor}}}}
\newcommand{\xor}{\ensuremath{\mathbin{\mathsf{xor}}}}
\newcommand{\rightshift}{\ensuremath{\mathbin{\mathsf{rshift}}}}
\newcommand{\leftshift}[1]{\ensuremath{\mathbin{\mathsf{lshift}_{#1}}}}

%% Notes and examples
\newcommand{\noteintro}[1]{[\textit{#1}:\space}
\newcommand{\noteoutro}[1]{\textit{\,---\,end #1}\kern.5pt]}
\newenvironment{note}[1][Note]{\noteintro{#1}}{\noteoutro{note}\space}
\newenvironment{example}[1][Example]{\noteintro{#1}}{\noteoutro{example}\space}

%% Library function descriptions
\newcommand{\Fundescx}[1]{\textit{#1}}
\newcommand{\Fundesc}[1]{\Fundescx{#1:}\space}
\newcommand{\required}{\Fundesc{Required behavior}}
\newcommand{\requires}{\Fundesc{Requires}}
\newcommand{\constraints}{\Fundesc{Constraints}}
\newcommand{\mandates}{\Fundesc{Mandates}}
\newcommand{\expects}{\Fundesc{Expects}}
\newcommand{\effects}{\Fundesc{Effects}}
\newcommand{\ensures}{\Fundesc{Ensures}}
\newcommand{\returns}{\Fundesc{Returns}}
\newcommand{\throws}{\Fundesc{Throws}}
\newcommand{\default}{\Fundesc{Default behavior}}
\newcommand{\complexity}{\Fundesc{Complexity}}
\newcommand{\remarks}{\Fundesc{Remarks}}
\newcommand{\errors}{\Fundesc{Error conditions}}
\newcommand{\sync}{\Fundesc{Synchronization}}
\newcommand{\implimits}{\Fundesc{Implementation limits}}
\newcommand{\replaceable}{\Fundesc{Replaceable}}
\newcommand{\returntype}{\Fundesc{Return type}}
\newcommand{\cvalue}{\Fundesc{Value}}
\newcommand{\ctype}{\Fundesc{Type}}
\newcommand{\ctypes}{\Fundesc{Types}}
\newcommand{\dtype}{\Fundesc{Default type}}
\newcommand{\ctemplate}{\Fundesc{Class template}}
\newcommand{\templalias}{\Fundesc{Alias template}}

%% Cross reference
\newcommand{\xref}{\textsc{See also:}\space}
\newcommand{\xrefc}[1]{\xref{} ISO C #1}

%% Inline parenthesized reference
\newcommand{\iref}[1]{\nolinebreak[3] (\ref{#1})}

%% Inline non-parenthesized table reference (override memoir's \tref)
\renewcommand{\tref}[1]{\tablerefname \nolinebreak[3] \ref{tab:#1}}

%% NTBS, etc.
\newcommand{\NTS}[1]{\textsc{#1}}
\newcommand{\ntbs}{\NTS{ntbs}}
\newcommand{\ntmbs}{\NTS{ntmbs}}
% The following are currently unused:
% \newcommand{\ntwcs}{\NTS{ntwcs}}
% \newcommand{\ntcxvis}{\NTS{ntc16s}}
% \newcommand{\ntcxxxiis}{\NTS{ntc32s}}

%% Code annotations
\newcommand{\EXPO}[1]{\textit{#1}}
\newcommand{\expos}{\EXPO{exposition only}}
\newcommand{\impdef}{\EXPO{implementation-defined}}
\newcommand{\impdefnc}{\EXPO{implementation-defined\nocorr}}
\newcommand{\impdefx}[1]{\indeximpldef{#1}\EXPO{implementation-defined}}
\newcommand{\notdef}{\EXPO{not defined}}

\newcommand{\UNSP}[1]{\textit{\texttt{#1}}}
\newcommand{\UNSPnc}[1]{\textit{\texttt{#1}\nocorr}}
\newcommand{\unspec}{\UNSP{unspecified}}
\newcommand{\unspecnc}{\UNSPnc{unspecified}}
\newcommand{\unspecbool}{\UNSP{unspecified-bool-type}}
\newcommand{\seebelow}{\UNSP{see below}}
\newcommand{\seebelownc}{\UNSPnc{see below}}
\newcommand{\seeref}[1]{\UNSP{see~\ref{#1}}}
\newcommand{\seerefnc}[1]{\UNSPnc{see~\ref{#1}}}
\newcommand{\unspecuniqtype}{\UNSP{unspecified unique type}}
\newcommand{\unspecalloctype}{\UNSP{unspecified allocator type}}

%% Manual insertion of italic corrections, for aligning in the presence
%% of the above annotations.
\newlength{\itcorrwidth}
\newlength{\itletterwidth}
\newcommand{\itcorr}[1][]{%
 \settowidth{\itcorrwidth}{\textit{x\/}}%
 \settowidth{\itletterwidth}{\textit{x\nocorr}}%
 \addtolength{\itcorrwidth}{-1\itletterwidth}%
 \makebox[#1\itcorrwidth]{}%
}

%% Double underscore
\newcommand{\ungap}{\kern.5pt}
\newcommand{\unun}{\textunderscore\ungap\textunderscore}
\newcommand{\xname}[1]{\tcode{\unun\ungap#1}}
\newcommand{\mname}[1]{\tcode{\unun\ungap#1\ungap\unun}}

%% An elided code fragment, /* ... */, that is formatted as code.
%% (By default, listings typeset comments as body text.)
%% Produces 9 output characters.
\newcommand{\commentellip}{\tcode{/* ...\ */}}

%% Concepts
\newcommand{\oldconcept}[1]{\textit{Cpp17#1}}
\newcommand{\oldconceptdefn}[1]{\defn{Cpp17#1}}
\newcommand{\idxoldconcept}[1]{Cpp17#1@\textit{Cpp17#1}}
\newcommand{\libconcept}[1]{\tcode{#1}}

%% Ranges
\newcommand{\Range}[4]{\tcode{#1#3,\penalty2000{} #4#2}}
\newcommand{\crange}[2]{\Range{[}{]}{#1}{#2}}
\newcommand{\brange}[2]{\Range{(}{]}{#1}{#2}}
\newcommand{\orange}[2]{\Range{(}{)}{#1}{#2}}
\newcommand{\range}[2]{\Range{[}{)}{#1}{#2}}

%% Change descriptions
\newcommand{\diffhead}[1]{\textbf{#1:}\space}
\newcommand{\diffdef}[1]{\hfill\break\diffhead{#1}}
\newcommand{\diffref}[1]{\pnum\textbf{Affected subclause:} \ref{#1}}
\newcommand{\diffrefs}[2]{\pnum\textbf{Affected subclauses:} \ref{#1}, \ref{#2}}
% \nodiffref swallows a following \change and removes the preceding line break.
\def\nodiffref\change{\pnum\diffhead{Change}}
\newcommand{\change}{\diffdef{Change}}
\newcommand{\rationale}{\diffdef{Rationale}}
\newcommand{\effect}{\diffdef{Effect on original feature}}
\newcommand{\effectafteritemize}{\diffhead{Effect on original feature}}
\newcommand{\difficulty}{\diffdef{Difficulty of converting}}
\newcommand{\howwide}{\diffdef{How widely used}}

%% Miscellaneous
\newcommand{\uniquens}{\placeholdernc{unique}}
\newcommand{\stage}[1]{\item[Stage #1:]}
\newcommand{\doccite}[1]{\textit{#1}}
\newcommand{\cvqual}[1]{\textit{#1}}
\newcommand{\cv}{\ifmmode\mathit{cv}\else\cvqual{cv}\fi}
\newcommand{\numconst}[1]{\textsl{#1}}
\newcommand{\logop}[1]{{\footnotesize #1}}

%%--------------------------------------------------
%% Environments for code listings.

% We use the 'listings' package, with some small customizations.  The
% most interesting customization: all TeX commands are available
% within comments.  Comments are set in italics, keywords and strings
% don't get special treatment.

\lstset{language=C++,
        basicstyle=\small\CodeStyle,
        keywordstyle=,
        stringstyle=,
        xleftmargin=1em,
        showstringspaces=false,
        commentstyle=\itshape\rmfamily,
        columns=fullflexible,
        keepspaces=true,
        texcl=true}

% Our usual abbreviation for 'listings'.  Comments are in
% italics.  Arbitrary TeX commands can be used if they're
% surrounded by @ signs.
\newcommand{\CodeBlockSetup}{%
\lstset{escapechar=@, aboveskip=\parskip, belowskip=0pt,
        midpenalty=500, endpenalty=-50,
        emptylinepenalty=-250, semicolonpenalty=0}%
\renewcommand{\tcode}[1]{\textup{\CodeStylex{##1}}}%
\renewcommand{\term}[1]{\textit{##1}}%
\renewcommand{\grammarterm}[1]{\gterm{##1}}%
}

\lstnewenvironment{codeblock}{\CodeBlockSetup}{}

% An environment for command / program output that is not C++ code.
\lstnewenvironment{outputblock}{\lstset{language=}}{}

% A code block in which single-quotes are digit separators
% rather than character literals.
\lstnewenvironment{codeblockdigitsep}{
 \CodeBlockSetup
 \lstset{deletestring=[b]{'}}
}{}

% Permit use of '@' inside codeblock blocks (don't ask)
\makeatletter
\newcommand{\atsign}{@}
\makeatother

%%--------------------------------------------------
%% Indented text
\newenvironment{indented}[1][]
{\begin{indenthelper}[#1]\item\relax}
{\end{indenthelper}}

%%--------------------------------------------------
%% Library item descriptions
\lstnewenvironment{itemdecl}
{
 \lstset{escapechar=@,
 xleftmargin=0em,
 midpenalty=500,
 semicolonpenalty=-50,
 endpenalty=3000,
 aboveskip=2ex,
 belowskip=0ex	% leave this alone: it keeps these things out of the
				% footnote area
 }
}
{
}

\newenvironment{itemdescr}
{
 \begin{indented}[beginpenalty=3000, endpenalty=-300]}
{
 \end{indented}
}


%%--------------------------------------------------
%% Bnf environments
\newlength{\BnfIndent}
\setlength{\BnfIndent}{\leftmargini}
\newlength{\BnfInc}
\setlength{\BnfInc}{\BnfIndent}
\newlength{\BnfRest}
\setlength{\BnfRest}{2\BnfIndent}
\newcommand{\BnfNontermshape}{\small\rmfamily\itshape}
\newcommand{\BnfTermshape}{\small\ttfamily\upshape}

\newenvironment{bnfbase}
 {
 \newcommand{\nontermdef}[1]{{\BnfNontermshape##1\itcorr}\indexgrammar{\idxgram{##1}}\textnormal{:}}
 \newcommand{\terminal}[1]{{\BnfTermshape ##1}}
 \newcommand{\descr}[1]{\textnormal{##1}}
 \newcommand{\bnfindent}{\hspace*{\bnfindentfirst}}
 \newcommand{\bnfindentfirst}{\BnfIndent}
 \newcommand{\bnfindentinc}{\BnfInc}
 \newcommand{\bnfindentrest}{\BnfRest}
 \newcommand{\br}{\hfill\\*}
 \widowpenalties 1 10000
 \frenchspacing
 }
 {
 \nonfrenchspacing
 }

\newenvironment{simplebnf}
{
 \begin{bnfbase}
 \BnfNontermshape
 \begin{indented}[before*=\setlength{\rightmargin}{-\leftmargin}]
}
{
 \end{indented}
 \end{bnfbase}
}

\newenvironment{bnf}
{
 \begin{bnfbase}
 \begin{bnflist}
 \BnfNontermshape
 \item\relax
}
{
 \end{bnflist}
 \end{bnfbase}
}

% non-copied versions of bnf environments
\let\ncsimplebnf\simplebnf
\let\endncsimplebnf\endsimplebnf
\let\ncbnf\bnf
\let\endncbnf\endbnf

%%--------------------------------------------------
%% Drawing environment
%
% usage: \begin{drawing}{UNITLENGTH}{WIDTH}{HEIGHT}{CAPTION}
\newenvironment{drawing}[4]
{
\newcommand{\mycaption}{#4}
\begin{figure}[h]
\setlength{\unitlength}{#1}
\begin{center}
\begin{picture}(#2,#3)\thicklines
}
{
\end{picture}
\end{center}
\caption{\mycaption}
\end{figure}
}

%%--------------------------------------------------
%% Environment for imported graphics
% usage: \begin{importgraphic}{CAPTION}{TAG}{FILE}

\newenvironment{importgraphic}[3]
{%
\newcommand{\cptn}{#1}
\newcommand{\lbl}{#2}
\begin{figure}[htp]\centering%
\includegraphics[scale=.35]{#3}
}
{
\caption{\cptn}\label{\lbl}%
\end{figure}}

%% enumeration display overrides
% enumerate with lowercase letters
\newenvironment{enumeratea}
{
 \renewcommand{\labelenumi}{\alph{enumi})}
 \begin{enumerate}
}
{
 \end{enumerate}
}

%%--------------------------------------------------
%% Definitions section for "Terms and definitions"
\newcounter{termnote}
\newcommand{\nocontentsline}[3]{}
\newcommand{\definition}[2]{%
\addxref{#2}%
\setcounter{termnote}{0}%
\let\oldcontentsline\addcontentsline%
\let\addcontentsline\nocontentsline%
\ifcase\value{SectionDepth}
         \let\s=\section
      \or\let\s=\subsection
      \or\let\s=\subsubsection
      \or\let\s=\paragraph
      \or\let\s=\subparagraph
      \fi%
\s[#1]{\hfill[#2]}\vspace{-.3\onelineskip}\label{#2} \textbf{#1}\\*%
\let\addcontentsline\oldcontentsline%
}
\newcommand{\defncontext}[1]{\textlangle#1\textrangle}
\newenvironment{defnote}{\addtocounter{termnote}{1}\noteintro{Note \thetermnote{} to entry}}{\noteoutro{note}\space}


% Definitions of table environments

%%--------------------------------------------------
%% Table environments

% Set parameters for floating tables
\setcounter{totalnumber}{10}

% Base definitions for tables
\newenvironment{TableBase}
{
 \renewcommand{\tcode}[1]{\CodeStylex{##1}}
 \newcommand{\topline}{\hline}
 \newcommand{\capsep}{\hline\hline}
 \newcommand{\rowsep}{\hline}
 \newcommand{\bottomline}{\hline}

%% vertical alignment
 \newcommand{\rb}[1]{\raisebox{1.5ex}[0pt]{##1}}	% move argument up half a row

%% header helpers
 \newcommand{\hdstyle}[1]{\textbf{##1}}				% set header style
 \newcommand{\Head}[3]{\multicolumn{##1}{##2}{\hdstyle{##3}}}	% add title spanning multiple columns
 \newcommand{\lhdrx}[2]{\Head{##1}{|c}{##2}}		% set header for left column spanning #1 columns
 \newcommand{\chdrx}[2]{\Head{##1}{c}{##2}}			% set header for center column spanning #1 columns
 \newcommand{\rhdrx}[2]{\Head{##1}{c|}{##2}}		% set header for right column spanning #1 columns
 \newcommand{\ohdrx}[2]{\Head{##1}{|c|}{##2}}		% set header for only column spanning #1 columns
 \newcommand{\lhdr}[1]{\lhdrx{1}{##1}}				% set header for single left column
 \newcommand{\chdr}[1]{\chdrx{1}{##1}}				% set header for single center column
 \newcommand{\rhdr}[1]{\rhdrx{1}{##1}}				% set header for single right column
 \newcommand{\ohdr}[1]{\ohdrx{1}{##1}}
 \newcommand{\br}{\hfill\break}						% force newline within table entry

%% column styles
 \newcolumntype{x}[1]{>{\raggedright\let\\=\tabularnewline}p{##1}}	% word-wrapped ragged-right
 																	% column, width specified by #1
 % \newcolumntype{m}[1]{>{\CodeStyle}l{##1}}              % variable width column, all entries in CodeStyle
 \newcolumntype{m}[1]{l{##1}}							% variable width column, all entries in CodeStyle

  % do not number bullets within tables
  \renewcommand{\labelitemi}{---}
  \renewcommand{\labelitemii}{---}
  \renewcommand{\labelitemiii}{---}
  \renewcommand{\labelitemiv}{---}
}
{
}

% General Usage: TITLE is the title of the table, XREF is the
% cross-reference for the table. LAYOUT is a sequence of column
% type specifiers (e.g. cp{1.0}c), without '|' for the left edge
% or right edge.

% usage: \begin{floattablebase}{TITLE}{XREF}{COLUMNS}{PLACEMENT}
% produces floating table, location determined within limits
% by LaTeX.
\newenvironment{floattablebase}[4]
{
 \begin{TableBase}
 \begin{table}[#4]
 \caption{\label{#2}#1}
 \begin{center}
 \begin{tabular}{|#3|}
}
{
 \bottomline
 \end{tabular}
 \end{center}
 \end{table}
 \end{TableBase}
}

% usage: \begin{floattable}{TITLE}{XREF}{COLUMNS}
% produces floating table, location determined within limits
% by LaTeX.
\newenvironment{floattable}[3]
{
 \begin{floattablebase}{#1}{#2}{#3}{htbp}
}
{
 \end{floattablebase}
}

% a column in a multicolfloattable (internal)
\newenvironment{mcftcol}{%
 \renewcommand{\columnbreak}{%
  \end{mcftcol} &
  \begin{mcftcol}
 }%
 \setlength{\tabcolsep}{0pt}%
 \begin{tabular}[t]{l}
}{
 \end{tabular}
}

% usage: \begin{multicolfloattable}{TITLE}{XREF}{COLUMNS}
% produces floating table, location determined within limits
% by LaTeX.
\newenvironment{multicolfloattable}[3]
{
 \begin{floattable}{#1}{#2}{#3}
 \topline
 \begin{mcftcol}
}
{
 \end{mcftcol} \\
 \end{floattable}
}

% usage: \begin{tokentable}{TITLE}{XREF}{HDR1}{HDR2}
% produces six-column table used for lists of replacement tokens;
% the columns are in pairs -- left-hand column has header HDR1,
% right hand column has header HDR2; pairs of columns are separated
% by vertical lines. Used in the "Alternative tokens" table.
\newenvironment{tokentable}[4]
{
 \begin{floattablebase}{#1}{#2}{cc|cc|cc}{htbp}
 \topline
 \hdstyle{#3}   &   \hdstyle{#4}    &
 \hdstyle{#3}   &   \hdstyle{#4}    &
 \hdstyle{#3}   &   \hdstyle{#4}    \\ \capsep
}
{
 \end{floattablebase}
}

% usage: \begin{libsumtabbase}{TITLE}{XREF}{HDR1}{HDR2}
% produces three-column table with column headers HDR1 and HDR2.
% Used in "Library Categories" table in standard, and used as
% base for other library summary tables.
\newenvironment{libsumtabbase}[4]
{
 \begin{floattable}{#1}{#2}{lll}
 \topline
 \lhdrx{2}{#3}	&	\hdstyle{#4}	\\ \capsep
}
{
 \end{floattable}
}

% usage: \begin{libsumtab}{TITLE}{XREF}
% produces three-column table with column headers "Subclause" and "Header(s)".
% Used in "C++ Headers for Freestanding Implementations" table in standard.
\newenvironment{libsumtab}[2]
{
 \begin{libsumtabbase}{#1}{#2}{Subclause}{Header(s)}
}
{
 \end{libsumtabbase}
}

% usage: \begin{concepttable}{TITLE}{TAG}{LAYOUT}
% produces table at current location
\newenvironment{concepttable}[3]
{
 \begin{TableBase}
 \begin{table}[!htb]
 \caption[#1]{\label{tab:#2}#1}
 \begin{center}
 \begin{tabular}{|#3|}
}
{
 \bottomline
 \end{tabular}
 \end{center}
 \end{table}
 \end{TableBase}
}

% usage: \begin{simpletypetable}{TITLE}{TAG}{LAYOUT}
% produces table at current location
\newenvironment{simpletypetable}[3]
{
 \begin{TableBase}
 \begin{table}[!htb]
 \caption{#1}\label{#2}
 \begin{center}
 \begin{tabular}{|#3|}
}
{
 \bottomline
 \end{tabular}
 \end{center}
 \end{table}
 \end{TableBase}
}

% usage: \begin{LongTable}{TITLE}{XREF}{LAYOUT}
% produces table that handles page breaks sensibly.
\newenvironment{LongTable}[3]
{
 \newcommand{\continuedcaption}{\caption[]{#1 (continued)}}
 \begin{TableBase}
 \begin{longtable}
 {|#3|}\caption{#1}\label{#2}
}
{
 \bottomline
 \end{longtable}
 \end{TableBase}
}

% usage: \begin{libreqtabN}{TITLE}{XREF}
% produces an N-column breakable table. Used in
% most of the library Clauses for requirements tables.
% Example at "Position type requirements" in the standard.

\newenvironment{libreqtab2}[2]
{
 \begin{LongTable}
 {#1}{#2}
 {lx{.55\hsize}}
}
{
 \end{LongTable}
}

\newenvironment{libreqtab2a}[2]
{
 \begin{LongTable}
 {#1}{#2}
 {x{.30\hsize}x{.64\hsize}}
}
{
 \end{LongTable}
}

\newenvironment{libreqtab3}[2]
{
 \begin{LongTable}
 {#1}{#2}
 {x{.28\hsize}x{.18\hsize}x{.43\hsize}}
}
{
 \end{LongTable}
}

\newenvironment{libreqtab3a}[2]
{
 \begin{LongTable}
 {#1}{#2}
 {x{.28\hsize}x{.33\hsize}x{.29\hsize}}
}
{
 \end{LongTable}
}

\newenvironment{libreqtab3b}[2]
{
 \begin{LongTable}
 {#1}{#2}
 {x{.40\hsize}x{.25\hsize}x{.25\hsize}}
}
{
 \end{LongTable}
}

\newenvironment{libreqtab3e}[2]
{
 \begin{LongTable}
 {#1}{#2}
 {x{.38\hsize}x{.27\hsize}x{.25\hsize}}
}
{
 \end{LongTable}
}

\newenvironment{libreqtab3f}[2]
{
 \begin{LongTable}
 {#1}{#2}
 {x{.35\hsize}x{.28\hsize}x{.29\hsize}}
}
{
 \end{LongTable}
}

\newenvironment{libreqtab4a}[2]
{
 \begin{LongTable}
 {#1}{#2}
 {x{.14\hsize}x{.30\hsize}x{.30\hsize}x{.14\hsize}}
}
{
 \end{LongTable}
}

\newenvironment{libreqtab4b}[2]
{
 \begin{LongTable}
 {#1}{#2}
 {x{.13\hsize}x{.15\hsize}x{.29\hsize}x{.27\hsize}}
}
{
 \end{LongTable}
}

\newenvironment{libreqtab4c}[2]
{
 \begin{LongTable}
 {#1}{#2}
 {x{.16\hsize}x{.21\hsize}x{.21\hsize}x{.30\hsize}}
}
{
 \end{LongTable}
}

\newenvironment{libreqtab4d}[2]
{
 \begin{LongTable}
 {#1}{#2}
 {x{.22\hsize}x{.22\hsize}x{.30\hsize}x{.15\hsize}}
}
{
 \end{LongTable}
}

\newenvironment{libreqtab5}[2]
{
 \begin{LongTable}
 {#1}{#2}
 {x{.14\hsize}x{.14\hsize}x{.20\hsize}x{.20\hsize}x{.14\hsize}}
}
{
 \end{LongTable}
}

% usage: \begin{libtab2}{TITLE}{XREF}{LAYOUT}{HDR1}{HDR2}
% produces two-column table with column headers HDR1 and HDR2.
% Used in "seekoff positioning" in the standard.
\newenvironment{libtab2}[5]
{
 \begin{floattable}
 {#1}{#2}{#3}
 \topline
 \lhdr{#4}	&	\rhdr{#5}	\\ \capsep
}
{
 \end{floattable}
}

% usage: \begin{longlibtab2}{TITLE}{XREF}{LAYOUT}{HDR1}{HDR2}
% produces two-column table with column headers HDR1 and HDR2.
\newenvironment{longlibtab2}[5]
{
 \begin{LongTable}{#1}{#2}{#3}
 \\ \topline
 \lhdr{#4}	&	\rhdr{#5}	\\ \capsep
 \endfirsthead
 \continuedcaption\\
 \topline
 \lhdr{#4}	&	\rhdr{#5}	\\ \capsep
 \endhead
}
{
  \end{LongTable}
}

% usage: \begin{LibEffTab}{TITLE}{XREF}{HDR2}{WD2}
% produces a two-column table with left column header "Element"
% and right column header HDR2, right column word-wrapped with
% width specified by WD2.
\newenvironment{LibEffTab}[4]
{
 \begin{libtab2}{#1}{#2}{lp{#4}}{Element}{#3}
}
{
 \end{libtab2}
}

% Same as LibEffTab except that it uses a long table.
\newenvironment{longLibEffTab}[4]
{
 \begin{longlibtab2}{#1}{#2}{lp{#4}}{Element}{#3}
}
{
 \end{longlibtab2}
}

% usage: \begin{libefftab}{TITLE}{XREF}
% produces a two-column effects table with right column
% header "Effect(s) if set", width 4.5 in. Used in "fmtflags effects"
% table in standard.
\newenvironment{libefftab}[2]
{
 \begin{LibEffTab}{#1}{#2}{Effect(s) if set}{4.5in}
}
{
 \end{LibEffTab}
}

% Same as libefftab except that it uses a long table.
\newenvironment{longlibefftab}[2]
{
 \begin{longLibEffTab}{#1}{#2}{Effect(s) if set}{4.5in}
}
{
 \end{longLibEffTab}
}

% usage: \begin{libefftabmean}{TITLE}{XREF}
% produces a two-column effects table with right column
% header "Meaning", width 4.5 in. Used in "seekdir effects"
% table in standard.
\newenvironment{libefftabmean}[2]
{
 \begin{LibEffTab}{#1}{#2}{Meaning}{4.5in}
}
{
 \end{LibEffTab}
}

% usage: \begin{libefftabvalue}{TITLE}{XREF}
% produces a two-column effects table with right column
% header "Value", width 3 in. Used in "basic_ios::init() effects"
% table in standard.
\newenvironment{libefftabvalue}[2]
{
 \begin{LibEffTab}{#1}{#2}{Value}{3in}
}
{
 \end{LibEffTab}
}

% usage: \begin{libefftabvaluenarrow}{TITLE}{XREF}
% produces a two-column effects table with right column
% header "Value", width 1.5 in. Used in basic_string_view effects
% tables in standard.
\newenvironment{libefftabvaluenarrow}[2]
{
 \begin{LibEffTab}{#1}{#2}{Value}{1.5in}
}
{
 \end{LibEffTab}
}

% Same as libefftabvalue except that it uses a long table and a
% slightly wider column.
\newenvironment{longlibefftabvalue}[2]
{
 \begin{longLibEffTab}{#1}{#2}{Value}{3.5in}
}
{
 \end{longLibEffTab}
}

% usage: \begin{liberrtab}{TITLE}{XREF} produces a two-column table
% with left column header ``Value'' and right header "Error
% condition", width 4.5 in. Used in regex Clause in the TR.

\newenvironment{liberrtab}[2]
{
 \begin{libtab2}{#1}{#2}{lp{4.5in}}{Value}{Error condition}
}
{
 \end{libtab2}
}

% Like liberrtab except that it uses a long table.
\newenvironment{longliberrtab}[2]
{
 \begin{longlibtab2}{#1}{#2}{lp{4.5in}}{Value}{Error condition}
}
{
 \end{longlibtab2}
}

% usage: \begin{lib2dtab2base}{TITLE}{XREF}{HDR1}{HDR2}{WID1}{WID2}{WID3}
% produces a table with one heading column followed by 2 data columns.
% used for 2D requirements tables, such as optional::operator= effects
% tables.
\newenvironment{lib2dtab2base}[7]
{
 %% no lines in the top-left cell, and leave a gap around the headers
 %% FIXME: I tried to use hhline here, but it doesn't appear to support
 %% the join between the leftmost top header and the topmost left header,
 %% so we fake it with an empty row and column.
 \newcommand{\topline}{\cline{3-4}}
 \newcommand{\rowsep}{\cline{1-1}\cline{3-4}}
 \newcommand{\capsep}{
  \topline
  \multicolumn{4}{c}{}\\[-0.8\normalbaselineskip]
  \rowsep
 }
 \newcommand{\bottomline}{\rowsep}
 \newcommand{\hdstyle}[1]{\textbf{##1}}
 \newcommand{\rowhdr}[1]{\hdstyle{##1}&}
 \newcommand{\colhdr}[1]{\multicolumn{1}{|>{\centering}m{#6}|}{\hdstyle{##1}}}
 %% FIXME: figure out a way to reuse floattable here
 \begin{table}[htbp]
 \caption{\label{#2}#1}
 \begin{center}
 \begin{tabular}{|>{\centering}m{#5}|@{}p{0.2\normalbaselineskip}@{}|m{#6}|m{#7}|}
 %% table header
 \topline
 \multicolumn{1}{c}{}&&\colhdr{#3}&\colhdr{#4}\\
 \capsep
}
{
 \bottomline
 \end{tabular}
 \end{center}
 \end{table}
}

\newenvironment{lib2dtab2}[4]{
 \begin{lib2dtab2base}{#1}{#2}{#3}{#4}{1.2in}{1.8in}{1.8in}
}{
 \end{lib2dtab2base}
}

%% Indices and glossaries
\makeindex[generalindex]
\makeindex[headerindex]
\makeindex[libraryindex]
\makeindex[grammarindex]
\makeindex[impldefindex]
\makeglossary[xrefindex]
\makeglossary[xrefdelta]

%%--------------------------------------------------
%% fix interaction between hyperref and other
%% commands
\pdfstringdefDisableCommands{\def\smaller#1{#1}}
\pdfstringdefDisableCommands{\def\textbf#1{#1}}
\pdfstringdefDisableCommands{\def\raisebox#1{}}
\pdfstringdefDisableCommands{\def\hspace#1{}}

%%--------------------------------------------------
%% add special hyphenation rules
\hyphenation{tem-plate ex-am-ple in-put-it-er-a-tor name-space name-spaces non-zero cus-tom-i-za-tion}

%%--------------------------------------------------
%% turn off all ligatures inside \texttt
\DisableLigatures{encoding = T1, family = tt*}


%%--------------------------------------------------
%% Title page for the C++ Standard

\ExplSyntaxOn
\cs_new:Nn \std_cover_draft: {
  \thispagestyle{empty}
  \begingroup
  \def\hd{\begin{tabular}{ll}
            \textbf{Document~Number:} & {\larger\tl_use:N \g_std_document_number_tl} \\
            \textbf{Date:}            & \tl_use:N \g_std_release_date_tl \\
            \textbf{Revises:}         & \tl_use:N \g_std_previous_document_number_tl \\
            \textbf{Reply~to:}        & \tl_use:N \g_std_editor_name_tl \\
                                      & \tl_use:N \g_std_editor_organization_tl \\
                                      & \tl_use:N \g_std_editor_email_tl
            \end{tabular}~
  }
  \newlength{\hdwidth}
  \settowidth{\hdwidth}{\hd}
  \hfill\begin{minipage}{\hdwidth}\hd\end{minipage}
  \endgroup

  \vspace{2.5cm}
  \begin{center}
  \textbf{\Huge
  Working~Draft,~Standard~for~Programming~Language~\Cpp{}}
  \end{center}
  \vfill
  \textbf{Note:~this~is~an~early~draft.~It's~known~to~be~incomplet~and~
    incorrekt,~and~it~has~lots~of~
    b\kern-1.2pta\kern1ptd\hspace{1.5em}for\kern-3ptmat\kern0.6ptti\raise0.15ex\hbox{n}g.}

  \clearpage
}

%%--------------------------------------------------
%% Title page for the C++ Standard

\cs_new:Nn \std_cover_final: {
  \setlength{\fboxsep}{1em}
  \newlength{\copyboxwidth}
  \setlength{\copyboxwidth}{\textwidth}
  \addtolength{\copyboxwidth}{-2\fboxsep}
  \addtolength{\copyboxwidth}{-2\fboxrule}

  \thispagestyle{empty}
  {\raisebox{.35ex}{\smaller\copyright}}\,ISO ~ 2017 ~ --- ~ All ~ rights ~ reserved
  \vspace{2ex}

  \begin{flushright}
    \textbf{ISO/IEC ~ JTC1 ~ SC22 ~ WG21 ~ N\,\LARGE3290}\par
    Date: ~ \reldate \par
    ISO/IEC ~ DIS ~ 14882 \par
    ISO/IEC ~ JTC1 ~ SC22 \par
    Secretariat: ~ ANSI \par
  \end{flushright}

  \vfill

  \textbf{\LARGE Programming ~ Languages ~ --- ~ \Cpp{}}
  \par
  Langages ~ de ~ programmation ~ --- ~ \Cpp{}

  \vfill

  \fbox{%
    \begin{minipage}{\copyboxwidth}%
      \vspace{1ex}%
      \begin{center}%
        \textbf{Warning}%
      \end{center}%
      \vspace{2ex}%

      This~document~is~not~an~ISO~International~Standard.~It~is~distributed~
      for~review~and~comment.~It~is~subject~to~change~without~notice~and~may~
      not~be~referred~to~as~an~International~Standard.\\[1em]

      Recipients~of~this~draft~are~invited~to~submit,~with~their~comments,~
      notification~of~any~relevant~patent~rights~of~which~they~are~aware~
      and~to~provide~supporting~documentation.\\
    \end{minipage}%
  }%

  \vfill
  \noindent
  Document~type:~Draft~International~Standard\\
  Document~stage:~(40)~Enquiry\\
  Document~Language:~E\par
  \pagebreak

  \thispagestyle{cpppage}

  \fbox{%
    \begin{minipage}{\copyboxwidth}%
      \vspace{1ex}%
      \begin{center}%
        \textbf{Copyright~notice}%
      \end{center}%
      \vspace{2ex}%

      All~rights~reserved.~Unless~otherwise~specified,~
      no~part~of~this~publication~may~be~reproduced~or~
      utilized~otherwise~in~any~form~or~by~any~means,~
      electronic~or~mechanical,~including~photocopying,~
      or~posting~on~the~internet~or~an~intranet,~
      without~prior~written~permission.~
      Permission~can~be~requested~
      from~either~ISO~at~the~address~below~
      or~ISO's~member~body~in~the~country~of~the~requester.\\\\

      \begin{indented}%
        \microtypesetup{activate=false}%
        ISO ~ copyright ~ office\\
        Case ~ postale ~ 56, ~ CH-1211 ~ Geneva ~ 20\\
        \rlap{Tel.}\hphantom{Fax} ~ + ~ 41 ~ 22 ~ 749 ~ 01 ~ 11\\
        Fax ~ + ~ 41 ~ 22 ~ 749 ~ 09 ~ 47\\
        E-mail ~ \texttt{copyright@iso.org}\\
        Web ~ \url{www.iso.org}%
      \end{indented}%
    \end{minipage}%
  }%

  \clearpage
}

\RenewDocumentCommand \maketitle { } {
  \bool_if:NTF \g_std_draft_bool {
    \std_cover_draft:
  } {
    \std_cover_final:
  }
}
\ExplSyntaxOff

%%--------------------------------------------------
%% Make a bit more room for our long page numbers.
\makeatletter
\renewcommand\@pnumwidth{2.5em}
\makeatother


\ExplSyntaxOn
\AtBeginDocument{%
  \title{C++ International Standard}
  \author{\tl_use:N \g_std_editor_name_tl}
  \chapterstyle{cppstd}%
  \pagestyle{cpppage}%
}
\ExplSyntaxOff

