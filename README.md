microEnem
================

O objetivo do pacote microEnem é facilitar a manipulação dos microdados
do Exame Nacional do Ensino Médio (Ennem). A versão atual permite
calcular a nota de um sujeito que respondeu os itens do Enem 2019. A
nota é calculada na mesma métrica do Enem. Para instalar pacote, use:

``` r
devtools::install_github('alexandrejaloto/microEnem')
```

Para calcular a nota de um sujeito, use a função `calcula.nota`

``` r
# importar primeiros 100 casos dos microdados de 2019
micro <- data.table::fread('MICRODADOS_ENEM_2019.csv', nrows = 100)

# selecionar quatro casos do cadernos 511 (LC, primeira aplicação)
resp <- micro$TX_RESPOSTAS_LC[c(84, 97:99)]

# calcular a nota
nota <- calc.nota(resp, codigo = 511)
```

Caso essa pessoa não tenha feito o Enem 2019 e não esteja nos
microdados, também é possível calcular sua nota:

``` r
# vetor de resposta de uma pessoa fictícia que respondeu o caderno de Linguagens e Códigos em 2019
resp <- c('99999BBDABBDBAADCBABBADAACBDDDDEACACBCACAABBBECBEC')

# calcular a nota
nota <- calc.nota(resp, codigo = 511)
```

É importante destacar que desde 2010 nos cadernos de Linguagens e
Códigos existem cinco itens de língua inglesa e cinco itens de língua
espanhola, por isso o vetor de respostas nessa área possui 50
caracteres. A pessoa responde somente uma dessas línguas e nos
microdados as respostas aos cinco itens da outra língua são marcados com
“9”. A função `calcula.nota` automaticamente transforma essa resposta
“9” em `NA` e esses itens não considerados para o cálculo.

Para separar cada resposta do sujeito que está no vetor único de
respostas, use a função `abre.resp`. Isso pode ser últil para utilizar
os dados do Enem em outros pacotes, como o mirt.

``` r
# vetor de resposta único
resp <- c('99999BBDABBDBAADCBABBADAACBDDDDEACACBCACAABBBECBEC')

# abrir o vetor de respostas
resp <- abre.resp(resp)
resp
```

Ainda que este pacote tenha sido elaborado por um pesquisador do Inep,
ele não configura um pacote oficial do instituto. Este trabalho não
representa necessariamente o ponto de vista do Inep. As opiniões
expressas nesta publicação são de inteira e exclusiva responsabilidade
do autor, não expressando necessariamente o ponto de vista do Inep ou do
Ministério da Educação.
