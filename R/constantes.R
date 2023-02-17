#' @title Constantes de transformação
#' @description Constantes de transformação da escala dos parâmetros
#' divulgados para a escala oficial do Enem
#'
#' @format Um objeto do tipo `data.frame` com as constantes de cada
#' área.
#'
#' Temos duas escalas: a escala oficial do Enem, cuja
#' referência são os concluintes regulares de escolas públicas do
#' Enem 2009 (média 500, desvio padrão 100); a escala dos
#' parâmetros dos microdados, cuja referência é a amostra de
#' calibração do Enem 2009 (média 0, desvio padrão 1).
#'
#' Para calcular as constantes de transformação de uma escala
#' para a outra, aplicamos a equalização linear
#' (Hambleton et al., 1991). Inicialmente estimamos
#' a nota dos primeiros 300.000 sujeitos do banco dos
#' microdados em cada área, de acordo com
#' as especificações em `calcula.nota`. Em seguida, estabelecemos
#' a igualdade entre a padronização das notas desses sujeitos:
#' \deqn{\frac{Y_{i}-\overline{Y}}{DP_{y}}=\frac{X_{i}-\overline{X}}{DP_{x}}}
#' Onde \eqn{Y_{i}} representa a nota do sujeito \eqn{i} na escala
#' oficial do Enem e \eqn{\overline{Y}} e \eqn{DP_{y}} representam a
#' média e o
#' desvio padrão das notas dessa amostra de 300.000 sujeitos nessa mesma
#' escala. \eqn{X_{i}} representa a nota do sujeito \eqn{i} na escala
#' dos parâmetros divulgados. \eqn{\overline{Y}} e \eqn{DP_{y}}
#' representam a média e o desvio padrão das notas da amostra nessa
#' escala.


#' Onde as notações com \eqn{Y} e \eqn{y} se referem às notas na escala oficial
#' do Enem, e as notações com \eqn{X} e \eqn{x} se referem às notas na
#' escala dos parâmetros divulgados. \eqn{Y_{i}} e \eqn{X_{i}}
#' correspondem à nota do sujeito \eqn{i}, \eqn{\overline{Y}} e
#' \eqn{\overline{X}} são a média desses 300.000 sujeitos e
#' \eqn{DP_{y}} e \eqn{DP_{x}} são o desvio padrão dessa amostra.
#'
#'
#' Nessa
#' equação, consideramos que as notas padronizadas das duas métricas
#' são iguais, pois provêm da mesma amostra. Porém, na prática elas
#' não são exatamente iguais, pois em uma calibração é pouco provável
#' que a distribuição de habilidades da amostra selecionada tenha
#' média exatamente zero e desvio padrão exatamente 1, apesar de
#' os programas (como o pacote mirt) assumirem esses valores para
#' identificação da métrica. Se isolarmos \eqn{Y_{i}}, teremos
#' (Muñiz, 1997):
#'
#' \deqn{Y_{i}=\frac{DP_{y}}{DP_{x}}X_{i}+\overline{Y}-\frac{DP_{y}}{DP_{x}}\overline{X}}
#'
#' Dessa equação, extraímos as constantes \eqn{k} e \eqn{d}:
#'
#' \deqn{k=\frac{DP_{y}}{DP_{x}}}
#'
#' \deqn{d=\overline{Y}-\frac{DP_{y}}{DP_{x}}\overline{X}}
#' \deqn{d=\overline{Y}-k\overline{X}}
#'
#' Portanto, para transformar a nota da escala dos microdados para a
#' escala oficial do Enem, utilizamos a seguinte equação:
#' \deqn{Y_{i}=kX_{i}+d}
#'
#'
'constantes'
