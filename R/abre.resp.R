#' @title Abre a resposta
#' @description Abre o vetor de resposta da variável TX_RESPOSTA
#'
#' @param unico vetor de respostas de um ou mais sujeitos no
#' formato da variável TX_RESPOSTA dos microdados do Enem
#'
#' @return Um objeto de classe `matrix` em que as colunas são os itens e as
#' linhas são os sujeitos
#'
#' @examples
#'
#' # importar primeiros 100 casos dos microdados de 2019
#' micro <- data.table::fread('MICRODADOS_ENEM_2019.csv', nrows = 100)
#'
#' resp <- abre.resp(micro$TX_RESPOSTAS_LC)
#' @export


abre.resp <- function (unico)
{
  resp. <- strsplit(as.character(as.matrix(unico)), NULL)
  resp <- do.call(rbind, resp.)
  return(resp)
}
