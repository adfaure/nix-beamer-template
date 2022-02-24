---
title: Ptask model invalidation
author: Adrien Faure
theme: Estonia
date: 2022-02-23
lang: fr
aspectratio: 169
header-includes:
- |
  ```{=latex}
  \usepackage{tikz}
  \usepackage{adjustbox}
  \usetikzlibrary{arrows,calc,intersections,decorations.pathreplacing,chains,matrix,positioning,scopes,shapes.misc,shapes.symbols,patterns, decorations.pathmorphing}
  \usepackage{subcaption}
  \setbeamertemplate{footline}[frame number]
  \renewcommand\dots{\ifmmode\ldots\else\makebox[1em][c]{.\hfil.\hfil.}\thinspace\fi}
  \hypersetup{colorlinks,linkcolor=,urlcolor=estonian-blue}
  \graphicspath{{../fig/},{../img/}}

  % Fix pandoc shenanigans
  \setbeamertemplate{section page}{}
  \setbeamertemplate{subsection page}{}
  \AtBeginSection{}
  \AtBeginSubsection{}

  \newcommand\blfootnote[1]{%
    \begingroup
    \renewcommand\thefootnote{}\footnote{#1}%
    \addtocounter{footnote}{-1}%
    \endgroup
  }

  \newcommand{\SimGrid}{SimGrid\xspace}
  \newcommand{\SG}{\SimGrid}

  \newcommand{\Ptask}{\emph{Ptask~}}
  \newcommand{\ptask}{\emph{ptask~}}
  \newcommand{\Ptasks}{\emph{Ptasks~}}
  \newcommand{\ptasks}{\emph{ptasks~}}
  ```
---

# Introduction

## HPC scheduling

```{=latex}
  \begin{columns}
    \begin{column}{0.56\textwidth}
      \centering
      \includegraphics[width=\textwidth,keepaspectratio]{../img/rjms_overview}
    \end{column}
    \begin{column}{0.44\textwidth}
      Plateforme partagée $\rightarrow$ plusieurs applications\\

      \vspace{1em}

      {\small RJMS :}
      \begin{itemize}
        \item Requêtes utilisateurs = jobs
        \item Ordonnancement et placement
        \item Gestion de la plateforme
        \begin{itemize}
          \item Contrôle l'exécution des jobs
          \item \emph{Monitoring} des noeuds
        \end{itemize}
        \item Logiciel complexe (milliers de lignes de code)
      \end{itemize}
    \end{column}
  \end{columns}
```

## How Study scheduling ?

- Scheduling is not anymore (only) about rectangles

- Most cluster uses simple policy (FCFS for instance)
    - With a backfilling mechanism

- Applications performance depends:
  - the capacity of the platform
  - their placement on the platform
  - and on the other application running

### Other points of concern arise at the scheduling level

- Energy optimization / management
- IO management


## Batsim: (Successful?) attempt to concentrate effort on RJMS simulation

```{=latex}
\begin{columns}
  \begin{column}{0.5\textwidth}
    \centering
    \includegraphics[width=\textwidth,keepaspectratio]{../img/batsim_overview.pdf}
  \end{column}
  \begin{column}{0.5\textwidth}
```

- Good idea in software engineering
  - separation of concerns
  - use Simgrid (platform + applications)

```{=latex}
   \begin{block}{"Realistic" view}
     \begin{itemize}
       \item Platform have defined network / nodes
       \item that (simulated) application can use with \textbf{profiles}
     \end{itemize}
   \end{block}
  \end{column}
\end{columns}


```

## Batsim with SimGrid: Application profiles

```{=latex}

\begin{columns}
  \begin{column}{0.5\textwidth}

    \begin{adjustbox}{max totalsize={0.8\textwidth}{\textheight},center}
      \begin{tikzpicture}

      \pgfmathsetmacro{\Xblock}{0}
      \draw (\Xblock+1.25,0) rectangle (\Xblock+5,1.5) node[midway] {job $j$};
      \draw[fill=gray] (\Xblock+5,0) rectangle (\Xblock+6,1.5) node[midway] {};

      \draw[->] (0,-0.75) -- (7,-0.75) node[sloped,below] {Time};
      \draw[->] (0,-0.75) -- (0,2.75) node[sloped,above,midway] {Resources};

      % rj
      \draw[dotted] (0.3,-0.75) -- (0.3,0.75);
      % startj
      \draw[dotted] (1.25,-0.75) -- (1.25,0.75);
      % Cj
      \draw[dotted] (5,-0.75) -- (5,0.75);

      \draw[dotted] (1.25,1.5) -- (1.25,2.1);
      \draw[dotted] (6,1.5) -- (6,2.1);
      \draw[dotted] (5,1.5) -- (5,1.75);

      \fill (0.3,-0.75) circle (0.05) node[sloped, below] {$r_j$};
      \fill (1.25,-0.75) circle (0.05) node[sloped, below] {$start_j$};
      \fill (5,-0.75) circle (0.05) node[sloped, below] {$C_j$};

      \draw[<->] (0.3,0.75) -- (1.25,0.75) node[midway,sloped,above] {$wait_j$};
      \draw[<->] (1.25,1.75) -- (5,1.75) node[midway,sloped,above] {$p_j$};
      \draw[<->] (1.25,2.25) -- (6,2.25) node[midway,sloped,above] {$wall_j$};
      \draw[<->] (6.25,0) -- (6.25,1.5) node[midway,sloped,right,rotate=-90] {$q_j$};
      \end{tikzpicture}
    \end{adjustbox}

    \vspace{1.5em}

    \textbf{Liste des jobs}
      \begin{itemize}
        \item Release date : $r_j$
        \item Number of resources : $q_j$
        \item Walltime : $wall_j$
        \item \textbf{1 simulation profile} : \textbf{$C_j$ ??}
      \end{itemize}

    \vspace{0.5em}
    \textbf{Running time $\rightarrow$ Depends on the profile}

  \end{column}

  \begin{column}{0.5\textwidth}

    \begin{block}{Nomenclature}
    \begin{itemize}
      \item \textbf{Job} is from the scheduler perspective
      \item \textbf{Application} defines what is running
      \item \textbf{Profile} is a Batsim's abstraction to model application
    \end{itemize}
    \end{block}

    \includegraphics[width=0.9\textwidth]{../img/workload}
  \end{column}
\end{columns}

```

# Profiles

## Profile Delay
```{=latex}
  \begin{columns}
    \begin{column}{0.5\textwidth}
      \textbf{Delay\\}
      \begin{itemize}
          \item Fixed execution time
          \item Static input
          \item The most used
      \end{itemize}
      ~ \\ ~ \\ ~ \\ ~ \\
      \textbf{Model inputs\\}
      \begin{itemize}
        \item Number of seconds
      \end{itemize}
    \end{column}
    \begin{column}{0.5\textwidth}
      \begin{block}{Properties}
        \begin{itemize}
          \item \textcolor{blue}{$+$ }Fast to compute
          \item \textcolor{red}{$-$ }No interference effects
          \item Realistic when :
          \begin{itemize}
            \item Homogeneous platform
            \item There is no interference
          \end{itemize}
        \end{itemize}
      \end{block}
    \end{column}
  \end{columns}
```

## Profile Time Independent Trace (TiT)

```{=latex}
  \begin{columns}
    \begin{column}{0.5\textwidth}
      \textbf{Time Independant Trace (TiT)\\}
      \begin{itemize}
        \item Fine grained model
        \item Replay SMPI traces
        \item Running time depends on :
          \begin{itemize}
            \item amount of work (cpu/network)
            \item platform capacity
            \item placement
            \item other jobs
          \end{itemize}
      \end{itemize}
      ~ \\
      \textbf{Model inputs\\}
      \begin{itemize}
        \item Trace TiT : List of SMPI calls to simulate
      \end{itemize}
    \end{column}
    \begin{column}{0.5\textwidth}
      \begin{block}{Properties}
        \begin{itemize}
          \item Only for MPI jobs
          \item \textcolor{blue}{$+$ } Inter / Intra interference effects
          \item \textcolor{blue}{$+$ } Has been validated~\cite{DBLP:conf/icppw/DesprezMQS11}
          \item \textcolor{red}{$-$ } Slow
          \item Realistic when :
          \begin{itemize}
            \item Static jobs MPI
            \item The performances doesn't depends on the data
          \end{itemize}
        \end{itemize}
      \end{block}
    \end{column}
  \end{columns}
```

## Profile Ptask

```{=latex}
  \begin{columns}
    \begin{column}{0.5\textwidth}
      \textbf{Parallel task model\\}
      \begin{itemize}
          \item Coarse graine model
          \item Homogeneous progression
          \item Running time depends on:
            \begin{itemize}
              \item Amount of work
              \item platform capacity
              \item placement
              \item other jobs
            \end{itemize}
          % \item \small Model from \SG
          \end{itemize}
          ~ \\
          \textbf{Model inputs\\}
          \begin{itemize}
          \item Utilise plusieurs ressources
            \begin{itemize}
              \item Array of computation amounts
              \item Communication matrix
            \end{itemize}
      \end{itemize}
    \end{column}
    \begin{column}{0.5\textwidth}
        \begin{block}{Properties}
          \begin{itemize}
            \item \textcolor{blue}{$+$ } Effets intra / inter jobs
            \item \textcolor{blue}{$+$ } Rapide
            \item \textcolor{red}{$-$ } Pas évalué avant cette thèse
            \item Réaliste quand : \textbf{?}
            % \begin{itemize}
            %   \item Cluster \textbf{hétéro}gène
            %   \item Contention intra $\&$ inter job
            %   \item Compromis performances / précision
            % \end{itemize}
          \end{itemize}
        \end{block}
        % \begin{flushright}
        %   \vspace{5em}
        %   \small
        %   \emph{Détaillé dans la prochaine section...}
        % \end{flushright}
    \end{column}
  \end{columns}
```

## Model performances

```{=latex}
  \centering
  \includegraphics[width=0.9\textwidth]{../img/defense_simulation_time_comparison_with_zoom}
  \blfootnote{\footnotesize Replay at: \url{https://gitlab.inria.fr/adfaure/ptask_tit_eval}}
```

## How to choose a model ?

```{=latex}
  \centering
  \textbf{We need to render resources consumption in simulation?}
  \begin{columns}
    \begin{column}{0.3\textwidth}

        \begin{block}{Profil Delay}
        \begin{itemize}
          \item Very fast
          \item No interference
          \item Poor in information
        \end{itemize}
        \vspace{1.5em}
        \end{block}
    \end{column}
    \begin{column}{0.39\textwidth}
      \only<1>{
        \begin{block}{profil \ptask}
      }
      \only<2>{
        \begin{alertblock}{profil \ptask}
      }
        \begin{itemize}
          \item Fast (enough)
          \item Interference effects
          \item \textbf{Resource comsumption}
            \begin{itemize}
              \item Computations and communications
            \end{itemize}
        \end{itemize}
      \only<1>{
        \end{block}
      }
      \only<2>{
        \end{alertblock}
      }
    \end{column}
    \begin{column}{0.3\textwidth}
        \begin{block}{profil TiT}
        \begin{itemize}
          \item Slow
          \item Interference effects
          \item Dedicated for MPI application
        \end{itemize}
        \vspace{1.5em}
        \end{block}
    \end{column}
  \end{columns}
  \vspace{2em} ~ \\
  \centering
  \Large
  \textbf{We need to validate the Ptask model}
\end{frame}
```

## Experimental methodology

```{=latex}
\begin{itemize}
  \item Network interference
  \item Comparison between simulation and reality
\end{itemize}

\vspace{1.5em}
\begin{columns}
  \begin{column}{0.5\textwidth}
    \begin{block}{Reality}
      \begin{itemize}
        \item Parallel application (MPI)
        \item Matrix product
        \item Controled interference generation
      \end{itemize}
    \end{block}
  \end{column}
  \begin{column}{0.5\textwidth}
    \begin{block}{Simulation}
      \begin{itemize}
        \item Execute one ptask
        \item Corresponding to our real application
        \item With the simulated interference
      \end{itemize}
    \end{block}
  \end{column}
\end{columns}
\blfootnote{Source code and data: \url{https://gitlab.inria.fr/adfaure/ptask\_tit\_eval}}
```
