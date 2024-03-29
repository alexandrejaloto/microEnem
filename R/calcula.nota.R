#' @title Calcula nota do Enem
#' @description Calcula a nota de um sujeito a escala do Enem (500, 100)
#'
#' @param resps vetor de respostas de um ou mais sujeitos. O
#' vetor deve ser no mesmo formato da variável TX_RESPOSTA
#' dos microdados do Enem. É importante destacar que desde 2010 nos
#' cadernos de Linguagens e Códigos existem cinco itens de língua
#' inglesa e cinco itens de língua espanhola, por isso em algumas edições
#' o vetor de
#' respostas nessa área possui 50 caracteres. A pessoa responde
#' somente uma dessas línguas e nos microdados as respostas aos cinco
#' itens da outra língua são marcados com "9". A função `calcula.nota`
#' automaticamente transforma essa resposta "9" em `NA` e esses
#' itens não considerados para o cálculo.
#' @param codigo código da prova disponível no dicionário dos
#' microdados. Essa informação também está disponível no
#' objeto `dic.cad` deste pacote
#' @param lingua vetor com indicação da língua estrangeira escolhida
#' pela pessoa. Essa informação corresponde à variável `TP_LINGUA`
#' nos microdados (`0` para inglês, `1` para espanhol).
#'
#' @details A nota é calculada pelo método expected a
#' posteriori (EAP), com 40 pontos de quadratura de -4 a 4.
#' A média da distribuição priori é 0 e o desvio padrão, 1. No
#' Enem as notas estão em uma escala com média 500 e desvio padrão
#' 100. A referência dessa escala são os concluintes regulares de
#' escola pública do Enem 2009. Ou seja, a média desses alunos
#' no Enem 2009 foi 500 e o desvio padrão, 100.
#'
#' Os parâmetros dos itens estão divulgados em uma escala com
#' média 0 e desvio padrão 1. A referência dessa escala é a
#' amostra utilizada na primeira calibração dos itens do Enem,
#' em 2009. Para posicionar os parâmetros na a escala oficial
#' do Enem, aplicamos as seguintes equações de
#' transformação:
#' \deqn{a_{enem} = \frac{a_{01}}{s}}
#' \deqn{b_{enem} = b_{01}*s+m}
#' \deqn{c_{enem} = c_{01}}
#' Onde \eqn{a_{enem}}, \eqn{b_{enem}} e \eqn{c_{enem}} são os
#' parâmetros dos itens na escala oficial do Enem,
#' \eqn{a_{01}}, \eqn{b_{01}} e \eqn{c_{01}} são os parâmetros
#' dos itens divulados nos microdados, e `k` e `d` são as
#' constantes de transformação da escala dos parâmetros divulgados
#' para a escala oficial. Essas constantes estão disponibilizadas
#' no objeto `constantes` deste pacote.
#'
#' @return as notas na escala oficial do Enem
#'
#' @examples
#' # importar primeiros 100 casos dos microdados de 2019
#' micro <- data.table::fread('MICRODADOS_ENEM_2019.csv', nrows = 100)
#'
#' # selecionar quatro casos do cadernos 511 (LC, primeira aplicação)
#' resp <- micro$TX_RESPOSTAS_LC[c(84, 97:99)]
#'
#' # calcular a nota
#' nota <- calc.nota(resp, codigo = 511)
#' nota
#'
#' # comparar com a nota oficial
#' micro$NU_NOTA_LC[c(84, 97:99)]
#'
#' # calcular a nota de um sujeito que não está nos microdados
#' # vetor de resposta de uma pessoa fictícia que respondeu o caderno de Linguagens e Códigos em 2019
#' resp <- c('99999BBDABBDBAADCBABBADAACBDDDDEACACBCACAABBBECBEC')
#'
#' # calcular a nota
#' nota <- calc.nota(resp, codigo = 511)
#' nota
#' @export


calc.nota <- function(
  resps,
  codigo = NULL,
  lingua = NULL
  # ano = NULL,
  # aplicacao = NULL,
  # area = NULL,
  # cor = NULL
){

  # modelo mirt do caderno
  mod <- mod.caderno(codigo = codigo)

  # gabarito do caderno
  key <- subset(itens, CO_PROVA == codigo)
  key <- dplyr::arrange(key, TP_LINGUA, CO_POSICAO)

  # verificar se algum item foi anulado
  anulado <- which(key$IN_ITEM_ABAN == 1)
  key <- subset(key, IN_ITEM_ABAN == 0)

  # abrir o vetor de respostas
  resp <- abre.resp(resps)

  # área e ano do caderno
  area <- dic.cad[dic.cad$codigo == codigo, 'area']
  ano <- dic.cad[dic.cad$codigo == codigo, 'ano']

  # transformar 9 em NA nos itens de língua estrangeira
  if (area == 'LC' & ano != 2009)
    {
    resp <- apply(resp, 2, \(x)ifelse(x == '9', NA, x))

    if (ano == 2022)
      resp <- insereNA(data = resp, lingua = lingua)
  }

  # retirar o item anulado da resposta
  if (length(anulado) > 0)
    if(length(resps) > 1)
    {resp <- resp[,-anulado]} else {resp <- t(data.frame(resp[,-anulado]))}

  # corrigir as respostas
  resp <- mirt::key2binary(resp, key$TX_GABARITO)

  # key$TX_GABARITO
  # calcular a nota
  nota <- data.frame(mirt::fscores(mod, response.pattern = resp, quadpts = 40, theta_lim = c(-4,4)))$F1

  # transformação da escala
  nota <- round(nota*constantes[constantes$area == area, 'k'] + constantes[constantes$area == area, 'd'], 1)

  return(nota)

}
