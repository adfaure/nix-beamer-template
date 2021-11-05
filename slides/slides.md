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


# Intro

### Intro subtitle

- Easy right ?
