% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mod.caderno.R
\name{mod.caderno}
\alias{mod.caderno}
\title{Modelo mirt do caderno}
\usage{
mod.caderno(codigo = NULL)
}
\arguments{
\item{codigo}{código da prova disponível no dicionário dos
microdados. Essa informação também está disponível no
objeto \code{dic.cad} deste pacote}
}
\value{
Um objeto \code{mirt} com informações sobre os
parâmetros dos itens e da amostra de calibração. Para
informações sobre esse objeto, consulte a documentação do
pacote \code{mirt}.
}
\description{
Gera um modelo do pacote mirt do caderno do Enem
}
\examples{

mod <- mod.caderno(511)
mirt::coef(mod, IRTpars = TRUE, simplify = TRUE)

}
