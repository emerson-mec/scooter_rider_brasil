import '../models/feed_model.dart';

List<FeedMODEL> feedDATA = [
  FeedMODEL(
    idFeed: "c1",
    tipoFeed: TipoFeed.review,
    titulo: 'Confira o review da Xmax 250',
    dataPublicacao: DateTime.now(),
    subtitulo: 'A Yamaha anunciou no inicio de 2020 a nova XMax para a Brasil.',
    conteudo:
        'Considerada pela marca como um ‘Sport Premium Scooter’, a novidade é equipada com uma série de recursos que lhe conferem comodidade e conforto. Na lista, há smart key (que também possibilita a abertura do tanque de combustível e do compartimento sob o assento, que comporta dois capacetes), tomada 12v, porta objetos junto à carenagem, para-brisa e guidão ajustáveis e, ainda, controle eletrônico de tração (cuja função é dosar a entrega de torque do motor para a roda traseira, evitando que ela destracione em situações de aceleração brusca ou quando o piso for escorregadio) – que pode ser desligado. Outro destaque interessante é o painel digital. Completo, ele informa sobre nível de combustível, temperatura do motor, hodômetro total e parcial, consumo instantâneo e autonomia, nível de carga da bateria, velocidade média, temperatura ambiente, relógio, indicador de troca da correia do CVT, indicador de troca do óleo do motor, e tempo de viagem.',
    imagemPrincipal:
        'https://www.motonline.com.br/noticia/wp-content/uploads/2019/11/salao-duas-rodas-MOTONLINE-triumph-honda-yamaha-cb-cbr-rocket-street-14.jpg',
  ),
  FeedMODEL(
    idFeed: "c2",
    tipoFeed: TipoFeed.noticia,
    titulo: 'Venda de motos crescem no ano de 2019',
    dataPublicacao: DateTime.now(),
    subtitulo:
        'A semana começa com uma boa notícia à crescente massa de usuários de scooters.',
    conteudo:
        'Considerada pela marca como um ‘Sport Premium Scooter’, a novidade é equipada com uma série de recursos que lhe conferem comodidade e conforto. Na lista, há smart key (que também possibilita a abertura do tanque de combustível e do compartimento sob o assento, que comporta dois capacetes), tomada 12v, porta objetos junto à carenagem, para-brisa e guidão ajustáveis e, ainda, controle eletrônico de tração (cuja função é dosar a entrega de torque do motor para a roda traseira, evitando que ela destracione em situações de aceleração brusca ou quando o piso for escorregadio) – que pode ser desligado. Outro destaque interessante é o painel digital. Completo, ele informa sobre nível de combustível, temperatura do motor, hodômetro total e parcial, consumo instantâneo e autonomia, nível de carga da bateria, velocidade média, temperatura ambiente, relógio, indicador de troca da correia do CVT, indicador de troca do óleo do motor, e tempo de viagem.',
    imagemPrincipal:
        'https://blog.hotmart.com/blog/2019/07/BLOG_vendas-670x419.png',
    favorito: true,
  ),
  FeedMODEL(
    idFeed: "c3",
    tipoFeed: TipoFeed.dica,
    titulo: 'Como limpar o espelhos sem arranha-lo',
    dataPublicacao: DateTime.now(),
    subtitulo: 'Confira os produtos que a SRB recomenda.',
    conteudo:
        'Considerada pela marca como um ‘Sport Premium Scooter’, a novidade é equipada com uma série de recursos que lhe conferem comodidade e conforto. Na lista, há smart key (que também possibilita a abertura do tanque de combustível e do compartimento sob o assento, que comporta dois capacetes), tomada 12v, porta objetos junto à carenagem, para-brisa e guidão ajustáveis e, ainda, controle eletrônico de tração (cuja função é dosar a entrega de torque do motor para a roda traseira, evitando que ela destracione em situações de aceleração brusca ou quando o piso for escorregadio) – que pode ser desligado. Outro destaque interessante é o painel digital. Completo, ele informa sobre nível de combustível, temperatura do motor, hodômetro total e parcial, consumo instantâneo e autonomia, nível de carga da bateria, velocidade média, temperatura ambiente, relógio, indicador de troca da correia do CVT, indicador de troca do óleo do motor, e tempo de viagem.',
    imagemPrincipal:
        'https://www.autostart.com.br/wp-content/uploads/2015/09/retrovisores-esportivos-para-motos-1.jpg',
  ),
  FeedMODEL(
    idFeed: "c4",
    tipoFeed: TipoFeed.evento,
    titulo: 'Bate e volta para Cabo frio em 25 de janeiro de 2020',
    dataPublicacao: DateTime.now(),
    subtitulo: 'Inscrições abertas até o dia 20 de janeiro.',
    conteudo:
        'Considerada pela marca como um ‘Sport Premium Scooter’, a novidade é equipada com uma série de recursos que lhe conferem comodidade e conforto. Na lista, há smart key (que também possibilita a abertura do tanque de combustível e do compartimento sob o assento, que comporta dois capacetes), tomada 12v, porta objetos junto à carenagem, para-brisa e guidão ajustáveis e, ainda, controle eletrônico de tração (cuja função é dosar a entrega de torque do motor para a roda traseira, evitando que ela destracione em situações de aceleração brusca ou quando o piso for escorregadio) – que pode ser desligado. Outro destaque interessante é o painel digital. Completo, ele informa sobre nível de combustível, temperatura do motor, hodômetro total e parcial, consumo instantâneo e autonomia, nível de carga da bateria, velocidade média, temperatura ambiente, relógio, indicador de troca da correia do CVT, indicador de troca do óleo do motor, e tempo de viagem.',
    imagemPrincipal:
        'https://www.viagenscinematograficas.com.br/wp-content/uploads/2019/05/Cabo-Frio-RJ-O-que-Fazer-2.jpg',
  ),
  FeedMODEL(
    idFeed: "c5",
    tipoFeed: TipoFeed.patrocinado,
    titulo: '5 dicas para melhorar a performance de seu scooter',
    dataPublicacao: DateTime.now(),
    subtitulo: 'A semana começa com uma boa.',
    conteudo:
        'Considerada pela marca como um ‘Sport Premium Scooter’, a novidade é equipada com uma série de recursos que lhe conferem comodidade e conforto. Na lista, há smart key (que também possibilita a abertura do tanque de combustível e do compartimento sob o assento, que comporta dois capacetes), tomada 12v, porta objetos junto à carenagem, para-brisa e guidão ajustáveis e, ainda, controle eletrônico de tração (cuja função é dosar a entrega de torque do motor para a roda traseira, evitando que ela destracione em situações de aceleração brusca ou quando o piso for escorregadio) – que pode ser desligado. Outro destaque interessante é o painel digital. Completo, ele informa sobre nível de combustível, temperatura do motor, hodômetro total e parcial, consumo instantâneo e autonomia, nível de carga da bateria, velocidade média, temperatura ambiente, relógio, indicador de troca da correia do CVT, indicador de troca do óleo do motor, e tempo de viagem.',
    imagemPrincipal:
        'https://http2.mlstatic.com/chip-para-aumento-de-potncia-e-perfomance-para-uno-14-D_NQ_NP_921906-MLB27962767056_082018-F.jpg',
  ),
];
