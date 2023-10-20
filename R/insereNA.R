#' @title Insere NA em TX_RESPOSTAS_LC
#' @description Insere NA para os itens não respondidos da língua estrangeira não selecionada
#'
#' @param data objeto do tipo matriz com as respostas
#' @param lingua vetor com indicação da língua estrangeira escolhida
#' pela pessoa. Essa informação corresponde à variável `TP_LINGUA`
#' nos microdados (`0` para inglês, `1` para espanhol).
#'
#' @noRd

insereNA <- function(data, lingua)
{
  if(class(data) == 'character')
  {data <- data.frame(t(data))} else {data <- data.frame(data)}

  data$id <- 1:nrow(data)

  eval (parse (text = paste0('XL', 1:10, " = NA")))

  # para quem respondeu inglês
  ingles <- subset (data, lingua == 0)
  if(nrow(ingles) > 0)
  {
    ingles <- cbind (ingles, XL1, XL2, XL3, XL4, XL5)
    ingles <- dplyr::select(ingles, id, dplyr::everything())
    names(ingles)[c(2:6)] <- paste0 ('X', 1:5)
    names(ingles)[c(7:46)] <- paste0 ('X', 11:50)
    names(ingles)[47:51] <- paste0 ('X', 6:10)
  }

  # para quem respondeu espanhol
  espanhol <- subset (data, lingua == 1)
  if(nrow(espanhol) > 0)
  {
    espanhol <- cbind (espanhol, XL6, XL7, XL8, XL9, XL10)
    espanhol <- dplyr::select(espanhol, id, dplyr::everything())
    names(espanhol)[2:46] <- paste0 ('X', 6:50)
    names(espanhol)[47:51] <- paste0 ('X', 1:5)
  }

  # juntar inglês com espanhol
  data.lingua <- data.frame(data.table::rbindlist(list (espanhol, ingles), fill = TRUE))

  # ordenar pelo id
  data.lingua <- dplyr::arrange(data.lingua, id)

  # excluir variável id e ordenar os itens
  data.lingua <- dplyr::select(data.lingua, paste0('X', 1:50))

  # as.matrix(data.lingua)
  return(as.matrix(data.lingua))

}
