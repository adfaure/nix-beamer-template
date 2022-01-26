---
title: A title
author: Your name
theme: Estonia
date: 2021-01-06
lang: fr
header-includes:
- |
  ```{=latex}
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
  ```
---

# Introduction

### Start the project

- Clone the repo and edit the file `slides/default.md`
- Build with nix `nix-build -A slides`
- Live edit with `nix-shell -A autorebuild-shell`

### Write directly in Markdown

- `#` title become Section
- `###` become slides
- Simple md is formatted in latex
- [Links also works](https://github.com/adfaure/nix-beamer-template)
- And tables


|Header|Column|
|------|------|
| H1   | H2   |

### Latex directives

#### Write directly in latex with `{=latex}`

````latex

```{=latex}
\begin{itemize}
  \item A more complicated item list
\end{itemize}
```

````


### Include figures

```
\includegraphics{../img/image.pdf}
```

### Bibliography

- Edit the file slides/bibliography.bib
- Use the latex command `\cite`

````latex
```{=latex}
Cite as usual with command \cite{veryseriousarticle}
```
````

#### Results

```{=latex}
Cite as usual with command \cite{veryseriousarticle}
```
