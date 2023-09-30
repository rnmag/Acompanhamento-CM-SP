# Script para acompanhamento das comissões e da Mesa Diretora da Câmara Municipal 
# de São Paulo. O código entra no site das comissões relevantes, baixa as listas 
# de membros e as compara com suas composições anteriores (chamada aqui de "re-
# ferência").

# Composição de referência ----------------------------------------------------
# Essa é a composição que o script vai usar como base de comparação. Se houver 
# qualquer alteração no site em relação a ela, o script manda uma mensagem nos 
# e-mails cadastrados e atualiza a composição. 
load("comissoes_referencia.RData")

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

# Baixar membros atuais das comissões -----------------------------------------
atual_mesa <- read_html("http://www.saopaulo.sp.leg.br/vereadores/?filtro=mesa-diretora") %>% 
  html_nodes(".vereador-name") %>% 
  html_text(., trim = TRUE) 

atual_ccj <- read_html("http://www.saopaulo.sp.leg.br/comissao/comissoes-do-processo-legislativo/comissao-de-constituicao-justica-e-legislacao-participativa/") %>% 
  html_nodes(".vereador-name") %>% 
  html_text() 

atual_cfo <- read_html("http://www.saopaulo.sp.leg.br/comissao/comissoes-do-processo-legislativo/comissao-de-financas-e-orcamento/") %>% 
  html_nodes(".vereador-name") %>% 
  html_text()

atual_met <- read_html("http://www.saopaulo.sp.leg.br/comissao/comissoes-do-processo-legislativo/comissao-de-politica-urbana-metropolitana-e-meio-ambiente/") %>% 
  html_nodes(".vereador-name") %>% 
  html_text()

atual_adm_pub <- read_html("http://www.saopaulo.sp.leg.br/comissao/comissoes-do-processo-legislativo/comissao-de-administracao-publica/") %>% 
  html_nodes(".vereador-name") %>% 
  html_text()

atual_transp <- read_html("http://www.saopaulo.sp.leg.br/comissao/comissoes-do-processo-legislativo/comissao-de-transito-transporte-atividade-economica-turismo-lazer-e-gastronomia/") %>% 
  html_nodes(".vereador-name") %>% 
  html_text()

atual_educ <- read_html("http://www.saopaulo.sp.leg.br/comissao/comissoes-do-processo-legislativo/comissao-de-educacao-cultura-e-esportes/") %>% 
  html_nodes(".vereador-name") %>% 
  html_text()

atual_trabalho <- read_html("http://www.saopaulo.sp.leg.br/comissao/comissoes-do-processo-legislativo/comissao-de-saude-promocao-social-trabalho-e-mulher/") %>% 
  html_nodes(".vereador-name") %>% 
  html_text()

# Checagem e envio das mensagens ----------------------------------------------
if (any(atual_mesa != referencia_mesa)) {
  msg_mesa <- envelope() %>%
    from("analisedeconjunturapolitica@gmail.com") %>%
    to(recipientes) %>%
    subject("Alerta: Novos Membros na Mesa Diretora (CM-SP)") %>%
    body(paste0(capture.output(
      cat(
        '<p> Oi,
        <br>
        <br>
        Detectei que foram alterados os membros da <b>Mesa Diretora/CM-SP</b>.
        <br>
        <br>
        <b>Sai(em):</b>',
        stri_trans_general(paste(capture.output(
          cat(setdiff(referencia_mesa, atual_mesa), sep = ", ")
        )), "Latin-ASCII"),
        '<br>
        <b>Entra(m)</b>:',
        stri_trans_general(paste(capture.output(
          cat(setdiff(atual_mesa, referencia_mesa), sep = ", ")
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
  referencia_mesa <- atual_mesa
  save.image("comissoes_referencia.RData")
  smtp(msg_mesa, verbose = TRUE)
}

if (any(atual_ccj != referencia_ccj)) {
  msg_ccj <- envelope() %>%
    from("analisedeconjunturapolitica@gmail.com") %>%
    to(recipientes) %>%
    subject("Alerta: Novos Membros na CCJ (CM-SP)") %>%
    body(paste0(capture.output(
      cat(
        '<p> Oi,
        <br>
        <br>
        Detectei que foram alterados os membros da <b>CCJ/CM-SP</b>.
        <br>
        <br>
        <b>Sai(em):</b>',
        stri_trans_general(paste(capture.output(
          cat(setdiff(referencia_ccj, atual_ccj), sep = ", ")
        )), "Latin-ASCII"),
        '<br>
        <b>Entra(m)</b>:',
        stri_trans_general(paste(capture.output(
          cat(setdiff(atual_ccj, referencia_ccj), sep = ", ")
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
  referencia_ccj <- atual_ccj
  save.image("comissoes_referencia.RData")
  smtp(msg_ccj, verbose = TRUE)
}

if (any(atual_cfo != referencia_cfo)) {
  msg_cfo <- envelope() %>%
    from("analisedeconjunturapolitica@gmail.com") %>%
    to(recipientes) %>%
    subject("Alerta: Novos Membros na CFO (CM-SP)") %>%
    body(paste0(capture.output(
      cat(
        '<p> Oi,
        <br>
        <br>
        Detectei que foram alterados os membros da <b>CFO/CM-SP</b>.
        <br>
        <br>
        <b>Sai(em):</b>',
        stri_trans_general(paste(capture.output(
          cat(setdiff(referencia_cfo, atual_cfo), sep = ", ")
        )), "Latin-ASCII"),
        '<br>
        <b>Entra(m)</b>:',
        stri_trans_general(paste(capture.output(
          cat(setdiff(atual_cfo, referencia_cfo), sep = ", ")
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
  referencia_cfo <- atual_cfo
  save.image("comissoes_referencia.RData")
  smtp(msg_cfo, verbose = TRUE)
}

if (any(atual_met != referencia_met)) {
  msg_met <- envelope() %>%
    from("analisedeconjunturapolitica@gmail.com") %>%
    to(recipientes) %>%
    subject("Alerta: Novos Membros na Com. de Pol. Urbana (CM-SP)") %>%
    body(paste0(capture.output(
      cat(
        '<p> Oi,
        <br>
        <br>
        Detectei que foram alterados os membros da <b>Com. de Pol. Urbana/CM-SP</b>.
        <br>
        <br>
        <b>Sai(em):</b>',
        stri_trans_general(paste(capture.output(
          cat(setdiff(referencia_met, atual_met), sep = ", ")
        )), "Latin-ASCII"),
        '<br>
        <b>Entra(m)</b>:',
        stri_trans_general(paste(capture.output(
          cat(setdiff(atual_met, referencia_met), sep = ", ")
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
  referencia_met <- atual_met
  save.image("comissoes_referencia.RData")
  smtp(msg_met, verbose = TRUE)
}


if (any(atual_adm_pub != referencia_adm_pub)) {
  msg_adm_pub <- envelope() %>%
    from("analisedeconjunturapolitica@gmail.com") %>%
    to(recipientes) %>%
    subject("Alerta: Novos Membros na Com. de Adm. Publica (CM-SP)") %>%
    body(paste0(capture.output(
      cat(
        '<p> Oi,
        <br>
        <br>
        Detectei que foram alterados os membros da <b>Com. de Adm. Publica/CM-SP</b>.
        <br>
        <br>
        <b>Sai(em):</b>',
        stri_trans_general(paste(capture.output(
          cat(setdiff(referencia_adm_pub, atual_adm_pub), sep = ", ")
        )), "Latin-ASCII"),
        '<br>
        <b>Entra(m)</b>:',
        stri_trans_general(paste(capture.output(
          cat(setdiff(atual_adm_pub, referencia_adm_pub), sep = ", ")
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
  referencia_adm_pub <- atual_adm_pub
  save.image("comissoes_referencia.RData")
  smtp(msg_adm_pub, verbose = TRUE)
}

if (any(atual_transp != referencia_transp)) {
  msg_transp <- envelope() %>%
    from("analisedeconjunturapolitica@gmail.com") %>%
    to(recipientes) %>%
    subject("Alerta: Novos Membros na Com. de Transportes (CM-SP)") %>%
    body(paste0(capture.output(
      cat(
        '<p> Oi,
        <br>
        <br>
        Detectei que foram alterados os membros da <b>Com. de Transportes/CM-SP</b>.
        <br>
        <br>
        <b>Sai(em):</b>',
        stri_trans_general(paste(capture.output(
          cat(setdiff(referencia_transp, atual_transp), sep = ", ")
        )), "Latin-ASCII"),
        '<br>
        <b>Entra(m)</b>:',
        stri_trans_general(paste(capture.output(
          cat(setdiff(atual_transp, referencia_transp), sep = ", ")
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
  referencia_transp <- atual_transp
  save.image("comissoes_referencia.RData")
  smtp(msg_transp, verbose = TRUE)
}

if (any(atual_educ != referencia_educ)) {
  msg_educ <- envelope() %>%
    from("analisedeconjunturapolitica@gmail.com") %>%
    to(recipientes) %>%
    subject("Alerta: Novos Membros na Com. de Cultura (CM-SP)") %>%
    body(paste0(capture.output(
      cat(
        '<p> Oi,
        <br>
        <br>
        Detectei que foram alterados os membros da <b>Com. de Cultura/CM-SP</b>.
        <br>
        <br>
        <b>Sai(em):</b>',
        stri_trans_general(paste(capture.output(
          cat(setdiff(referencia_educ, atual_educ), sep = ", ")
        )), "Latin-ASCII"),
        '<br>
        <b>Entra(m)</b>:',
        stri_trans_general(paste(capture.output(
          cat(setdiff(atual_educ, referencia_educ), sep = ", ")
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
  referencia_educ <- atual_educ
  save.image("comissoes_referencia.RData")
  smtp(msg_educ, verbose = TRUE)
}

if (any(atual_trabalho != referencia_trabalho)) {
  msg_trabalho <- envelope() %>%
    from("analisedeconjunturapolitica@gmail.com") %>%
    to(recipientes) %>%
    subject("Alerta: Novos Membros na Com. de Trabalho e Mulher (CM-SP)") %>%
    body(paste0(capture.output(
      cat(
        '<p> Oi,
        <br>
        <br>
        Detectei que foram alterados os membros da <b>Com. de Trabalho e Mulher/CM-SP</b>.
        <br>
        <br>
        <b>Sai(em):</b>',
        stri_trans_general(paste(capture.output(
          cat(setdiff(referencia_trabalho, atual_trabalho), sep = ", ")
        )), "Latin-ASCII"),
        '<br>
        <b>Entra(m)</b>:',
        stri_trans_general(paste(capture.output(
          cat(setdiff(atual_trabalho, referencia_trabalho), sep = ", ")
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
  referencia_trabalho <- atual_trabalho
  save.image("comissoes_referencia.RData")
  smtp(msg_trabalho, verbose = TRUE)
}
