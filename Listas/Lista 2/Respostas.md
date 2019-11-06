  # Respostas | Lista de Exercícios 2

*Infraestrutura de Hardware (IF674)*
*Universidade Federal de Pernambuco*

- Erick Almeida <eaor@cin.ufpe.br>
- Guilherme Afonso <gasp@cin.ufpe.br>
- Heitor Santos <hss2@cin.ufpe.br>
- Marconi Gomes <mgrf@cin.ufpe.br>
- Tiago Campelo <tscs2@cin.ufpe.br>

## Questão 1

### a)

Existem 3 tipos de conflitos que podem ocorrer: as **estruturais**, as de **dados** e as de **controle**.

**Estruturais**: Quando um recurso de hardware é solicitado por uma instrução enquanto outra está usando o mesmo recurso. Um exemplo é o seguinte código de assembly:

    add $1, $2, $3
    sub $4, $1, $2
    sub $4, $5, $5

Na execução da instrução 3, a etapa ID terá que esperar para ser executada, pois a instrução 2 demorará mais, considerando que ela depende da instrução 1 para ser executada.

**Dados**: Quando há dependência de dados entre instruções. Um exemplo é o seguinte código de assembly.

    add $1, $2, $3
    sub $4, $1, $2

A execução da instrução 2 depende de um dado a ser calculado na instrução 1, e portanto é necessário aguardar pela escrita do resultado da primeira instrução.

**Controles**: Quando a decisão da próxima instrução a ser executada depende da instrução anterior. Um exemplo é o seguinte código assembly:

    beq $1, $zero, NO
    add $3, $4, $5
    NO:
    sub $3, $4, $5

A execução da instrução 2 depende do resultado do ```beq``` (*branch equal*) para decidir se ela será executada ou não.

### b)

Para os conflitos estruturais, podemos **replicar recursos**, **inserir retardos (stalls)** ou **inserir NOPs no código**. Para os conflitos de dados, podemos **inserir NOPs no código**, **rearrumar o código**, **utilizar o método de curto-circuito** ou **inserir retardos (stalls)**. Já para os conflitos de controle, podemos **rearrumar o código**, **congelar o pipeline**, utilizar **execução especulativa** ou **acelerar a avaliação do desvio**.

_Hardware_

**Replicar recursos**: Adicionar mais recursos no hardware para que não haja dependência.

**Método de curto-circuito**: Adicionar conexões extras ao hardware para utilizar o resultado desejado assim que é computado, sem esperar o armazenamento no registrador. 

**Inserir retardos (stalls)**: Fazer com que o hardware espere para continuar a execução de uma instrução.

**Congelamento de pipeline**: Inserir retardos até que se saiba se o desvio ocorrerá. Só depois do fim da instrução é que se busca uma nova.

**Execução especulativa**: Continuar executando as próximas instruções, ainda que não se saiba se eles devem ser executados. Caso se confirme que elas não deveriam ser executadas, elas são revertidas através de um *flush*. A execução especulativa pode ser *estática* (o processador toma a decisão especulando que nunca haverá desvio ou sempre haverá desvio) ou *dinâmica* (o processador especula de acordo com o comportamento do código).

**Acelerar a avaliação do desvio**: Adicionar um hardware que calcula o resultado do desvio no estágio ID. 

_Software_

**Inserção de NOPs no código**: Compilador identifica conflitos e os evita adicionando um NOP (instrução que não realiza nenhuma operação) no código, fazendo que o processador "espere" até ser realizada uma nova instrução.

**Rearrumação de código**: Compilador reorganiza o código para evitar conflitos (por exemplo, alterando operações de lugar e executando instruções que não tem dependência entre si, sem que afete a corretude do código).

****

## Questão 2

### a)

**Monociclo**: Num processador monociclo, uma instrução é executada por vez, e cada instrução demora exatamente um ciclo para ser executada. Essa é uma abordagem mais simples de implementar, porém lenta, pois os ciclos precisam ser grandes para comportar cada uma das instruções, e como existem instruções que usam menos ou mais hardware, as instruções menos complexas vão demorar o mesmo tempo que as mais complexas, tornando a execução mais lenta. Além disso, é mais cara pois devido à restrição de um ciclo por instrução, se faz necessária a duplicação de componentes.

**Multiciclo**: Num processador multiciclo, uma instrução é executada por vez, mas cada instrução é dividida em diferentes estágios, e cada estágio é executado em um ciclo de clock. Essa implementação é mais eficiente que a monociclo, pois algumas instruções podem ser processadas em menos tempo, e o mesmo componente de hardware pode ser utilizado em estágios diferentes.

**Pipeline**: Num processador que utiliza arquitetura pipeline, definindo uma sequência comum de passos para as instruções, podemos fazer com que instruções executem ao mesmo tempo, operações diferentes desde que não usem os mesmos componentes de Hardware. Usando registradores intermediários e um cálculo prévio dos sinais de controle, podemos fazer com que várias instruções estejam executando um estágio diferente dentro do mesmo processador. Com a possibilidade de executar várias instruções ao mesmo tempo temos que alguns conflitos ocasionalmente possam surgir, tais quais: Dependência de dados, conflito no uso das esrtruturas internas e falhas no controle de execução. Dito isso, é necessário que o pipeline esteja muito bem estruturado (em questão de número de estados e componentes) para que os conflitos que possam vir a ocorrer sejam mínimos e tratados com eficiência caso ocorram.


### b)
O MIPS facilita a implementação de pipeline pelos seguintes motivos:
- Todas as instruções são de 32 bits: isso torna mais fácil de buscar e decodificar em um ciclo.
- Poucas instruções e instruções regulares: permite decodificação e leitura de registradores em um estágio.
- Endereçamento de load/store permite cálculo de endereço no terceiro estágio e acesso no quarto estágio.

### c)
Alguns fatores que podem afetar o desempenho são a quantidade de conflitos e o número de estágios. Implementando as soluções de hardware e software de resolução de conflitos ajudará consideravelmente no desempenho. Outro fator importante é a quantidade de estágios das instruções. Intuitivamente poderíamos pensar que aumentar a quantidade de estágios e aumentar a frequência do clock resolveria de uma vez por todas os problemas de desempenho do pipeline, entretanto a sua performance relativa é afetada quando o número de estágios é muito alto. Um claro exemplo se dá quando pensarmos que o conflito no uso de componentes se tornará mais frequente já que as instruções estão divididas em mais partes, então é necessário escollher o número ideal de estágios para o pipeline para que ele tenha o melhor desempenho possível.

****

## Questão 3
O objetivo das multithreads é aumentar o desempenho do processador. Através de múltiplos cores, conseguimos também a eficiência de multithreading, já que isso irá permitir o aumento do uso de threads simultâneas em execução dentro de um único processador, sem abrir mão da potência dissipada. De forma a inserir uma lógica de controle e duplicação das unidades referentes ao contexto da thread em execução (oferecendo uma troca de contexto eficiente), podemos maximizar o uso dos componentes de hardware e permitir concorrência na execução das threads.

Algumas implementações de threads foram desenvolvidas ao longo do tempo, tais quais:
- **Fine-grain**: O processador troca de thread em cada instrução pulando threads paradas, fazendo isso a cada ciclo de clock. Sua vantagem é diminuir a perda de vazão pela existência de threads paradas, que também acaba se tornando uma desvantages pois a troca de threads é excessiva prejudicando threads que não estão paradas no momento.
- **Coarse-grain**: Neste esquema, a troca de threads só ocorre em threads de paradas longas, esperando aquelas que são de paradas curtas, evitando uma troca excessiva, aumentando a velocidade de processamento. Entretanto, isso causará perde de vazão por paradas curtas, afetando também o pipeline que deverá ser alunado e preenchido na troca de threads devido às paradas longas.
- **SMT**: Multi-threading para processadores superescalares, isso proporciona paralelismo a nível de thread e a nível de instrução, porém é mais custoso.
## Questão 4

### a) 
A técnica de implementação do Superpipeline consiste em "quebrar" os estágios existentes em estágios menores que realizam menos trabalho, possibilitando por exemplo, um aumento na frequência de clock já que teremos estágios com menor tempo de execução, atingindo um desempenho melhor sobre o pipeline. Entretanto, o superpipeline só é efetivamente mais eficiente até um certo momento, pois uma maior quantidade de estágios traz consigo uma maior quantidade de conflitos (Dados: mais dependência, Controle: mais sinais de controle precisam ser calculados e definidos com seus controles corretos) que são capazes de serem gerados. Além dessas características, teremos um aumento no custo de hardware.

### b)
A técnica de implementação do Superescalar consiste em permitir que várias instruções possam começar ao mesmo tempo, seperando o hardware em unidades de processamento, para que possamos executar mais instruções ao mesmo tempo. Definimos o grau **N** de superescalar como sendo o número de instruçẽos que são replicadas. Seu grande benefício é oferecimento de paralelismo real (já que **N** instruções podem iniciar ao mesmo tempo). Ao mesmo tempo,sua desvantagem é que os componentes de hardware precisarão ser duplicados ou modificados. A ULA por exemplo, precisará realizar operações aritméticas/branches ao mesmo tempo que acessa a memória, banco de registradores capaz de fazer 2*N leituras ao mesmo tempo, etc. No caso de ser um superescalar de fato (e não um VLIW), a execução ainda é atrasada porque o processador ainda tem que escolher quais instruções podem ser executadas ao mesmo tempo.

## Questão 5
Processadores multicore são processadores com vários núcleos atuando ao mesmo tempo. A comunicação entre os processadores pode ser feita de duas formas diferentes: com memória compartilhada ou passagem de mensagem. No primeiro caso, há variáveis compartilhadas entre os processadores, e só um processador por vez pode acessar a uma dessas variáveis. Para isso é utilizado o semáforo (lock), com o comando ```ll```, o processador vê se o semáforo está livre, caso negativo segue tentando acessar, caso positivo acessa a região, usa o comando ```sc=1``` para dizer q a região está ocupada, faz as alterações que deseja e depois ```sc=0``` para liberar o semáforo. Com passagem de mensagem os processadores compartilham explicitamente os dados e eles se comunicam através de primitivas de comunicação (*send* e *receive*).
