#' @title Modelo mirt do caderno
#' @description Gera um modelo do pacote mirt do caderno do Enem
#'
#' @param codigo código da prova disponível no dicionário dos
#' microdados. Essa informação também está disponível no
#' objeto `dic.cad` deste pacote
#'
#' @return Um objeto `mirt` com informações sobre os
#' parâmetros dos itens e da amostra de calibração. Para
#' informações sobre esse objeto, consulte a documentação do
#' pacote `mirt`.
#'
#'
#' @examples
#'
#' mod <- mod.caderno(511)
#' mirt::coef(mod, IRTpars = TRUE, simplify = TRUE)
#'
#' @export

mod.caderno <- function(
  codigo = NULL
  # ano = NULL,
  # aplicacao = NULL,
  # area = NULL,
  # cor = NULL
){
  itens.mirt <- subset(itens, CO_PROVA == codigo & IN_ITEM_ABAN == 0)

  itens.mirt <- dplyr::arrange(itens.mirt, TP_LINGUA, CO_POSICAO)
  itens.mirt <- itens.mirt[,8:10]
  names(itens.mirt) <- c('a1', 'd', 'g')

  itens.mirt$a1 <- as.numeric(itens.mirt$a1)
  itens.mirt$d <- as.numeric(itens.mirt$d)
  itens.mirt$g <- as.numeric(itens.mirt$g)
  itens.mirt$d <- itens.mirt$a1*-itens.mirt$d

  mod <- mirtCAT::generate.mirt_object(
    itens.mirt,
    '3PL'
  )

  return(mod)
}
