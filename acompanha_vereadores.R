# Script para acompanhamento dos vereadores da Câmara Municipal de São Paulo. O
# código entra no site da Casa, baixa a lista de membros com mandato e a compara
# com a composição anterior (chamada aqui de "referência").

# Composição de referência ----------------------------------------------------
# Essa é a composição que o script vai usar como base de comparação. Se houver 
# qualquer alteração no site em relação a ela, o script manda uma mensagem nos 
# e-mails cadastrados e atualiza a composição. 
load("vereadores_referencia.RData")

# E-mails que vão receber o alerta e configurações de envio -------------------
recipientes <- c("rafael.nunes@ibureau.com.br",
                 "isllane@ibureau.com.br",
                 "camila.salvatore@ibureau.com.br",
                 "mariana.chaimovich@ibureau.com.br",
                 "monica.rezende@ibureau.com.br")

smtp <- server(host = "smtp.gmail.com",
               port = 465,
               username = "analisedeconjunturapolitica@gmail.com",
               password = "Politic@2019")

# Baixar membros atuais da Casa -----------------------------------------------
pagina <- "http://www.saopaulo.sp.leg.br/vereadores/"

vereadores_atuais <- read_html(pagina) %>% 
  html_nodes(".vereador-name") %>% 
  html_text(., trim = TRUE)

partidos_atuais <- read_html(pagina) %>% 
  html_nodes("h3 img") %>% 
  html_attr("title")

atual_legislatura <- paste0(vereadores_atuais, " (", partidos_atuais, ")")

# Checagem e envio das mensagens ----------------------------------------------
if (any(atual_legislatura != referencia_legislatura)) {
  msg_vereadores <- envelope() %>%
    from("analisedeconjunturapolitica@gmail.com") %>%
    to(recipientes) %>%
    subject("Alerta: Legisladores e Partidos na CM-SP") %>%
    body(paste0(capture.output(
      cat(
        '<p> Oi,
        <br>
        <br>
        Detectei que foram alterados legisladores e/ou partidos da <b>CM-SP</b>.
        <br>
        <br>
        <b>Como era</b>:',
        stri_trans_general(paste(capture.output(
          cat(setdiff(referencia_legislatura, atual_legislatura), sep = ", ")
        )), "Latin-ASCII"),
        '<br>
        <b>Como ficou</b>:',
        stri_trans_general(paste(capture.output(
          cat(setdiff(atual_legislatura, referencia_legislatura), sep = ", ")
        )), "Latin-ASCII"),
        '<br>
        <br>
        Estou olhando todo dia, e te aviso quando mudar de novo!
        <br>
        <br>
        Atenciosamente,
        <br>
        <b>ACP_bot</b>
        </p>'
      )
    ), collapse = ""), type = "html")
  referencia_legislatura <- atual_legislatura
  save.image("vereadores_referencia.RData")
  smtp(msg_vereadores, verbose = TRUE)
}
