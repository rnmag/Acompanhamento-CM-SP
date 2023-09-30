# Script para acompanhamento das lideranças da Câmara Municipal de São Paulo. O
# código entra no site da Casa, baixa a lista de membros e a compara com a com-
# posição anterior (chamada aqui de "referência").

# Composição de referência ----------------------------------------------------
# Essa é a composição que o script vai usar como base de comparação. Se houver 
# qualquer alteração no site em relação a ela, o script manda uma mensagem nos 
# e-mails cadastrados e atualiza a composição. 
load("liderancas_referencia.RData")

# E-mails que vão receber o alerta + configurações de envio -------------------
recipientes <- c("rafael.nunes@ibureau.com.br",
                 "isllane@ibureau.com.br",
                 "camila.salvatore@ibureau.com.br",
                 "mariana.chaimovich@ibureau.com.br",
                 "monica.rezende@ibureau.com.br")

smtp <- server(host = "smtp.gmail.com",
               port = 465,
               username = "analisedeconjunturapolitica@gmail.com",
               password = "Politic@2019")

# Baixar líderes atuais -------------------------------------------------------
pagina <- "http://www.saopaulo.sp.leg.br/vereadores/?filtro=liderancas"

liderancas_atuais <- read_html(pagina) %>% 
  html_nodes(".vereador-name") %>% 
  html_text(., trim = TRUE) %>% 
  stri_replace_all_regex(., "[\t\r\n]", "")

partidos_atuais <- read_html(pagina) %>% 
  html_nodes("h3 img") %>% 
  html_attr("title") %>% 
  replace(., length(.), "Lider de Governo") # Para acomodar um líder não partid.

atual_lideres <- paste0(liderancas_atuais, " - ", partidos_atuais)

# Checagem e envio das mensagens ----------------------------------------------
if (any(atual_lideres != referencia_lideres)) {
  msg_lideres <- envelope() %>%
    from("analisedeconjunturapolitica@gmail.com") %>%
    to(recipientes) %>%
    subject("Alerta: Alterados os lideres na CM-SP") %>%
    body(paste0(capture.output(
      cat(
        '<p> Oi,
        <br>
        <br>
        Detectei que foram alterados lideres da <b>CM-SP</b>.
        <br>
        <br>
        <b>Sai(em)</b>:',
        stri_trans_general(paste(capture.output(
          cat(setdiff(referencia_lideres, atual_lideres), sep = ", ")
        )), "Latin-ASCII"),
        '<br>
        <b>Entra(m)</b>:',
        stri_trans_general(paste(capture.output(
          cat(setdiff(atual_lideres, referencia_lideres), sep = ", ")
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
  referencia_lideres <- atual_lideres
  save.image("liderancas_referencia.RData")
  smtp(msg_lideres, verbose = TRUE)
}
