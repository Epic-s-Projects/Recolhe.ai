<br>
<br>
<br>
<p align="center">
   <img src="/exemplo_firebase/assets/recycle_icon.png" alt="logo" width=250px>
</p>

<p align="center">
   <img src="https://img.shields.io/badge/Backend-FEITO-blue?style=for-the-badge" alt="backend" />
  <img src="https://img.shields.io/badge/Documentação-FEITA-blue?style=for-the-badge" alt="documentação" />
  <img src="https://img.shields.io/badge/Protótipos-FEITO-blue?style=for-the-badge" alt="prototipos" />
  <img src="https://img.shields.io/badge/Frontend-FEITO-blue?style=for-the-badge" alt="frontend" />
</p>
<hr>
<br>
<br><br><br>


<img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=440&size=22&pause=1000&color=38F77CFF&center=false&vCenter=false&repeat=false&width=435&lines=Sumário 📰" alt="Typing SVG" /></a>

- [Contexto Inicial](#contexto-inicial)
- [Problema Encontrado](#problema-encontrado)
- [Nossa Solução](#nossa-solução)
- [Protótipos](#protótipos)
- [Diagramas](#diagramas)
- [Funcionalidades do Aplicativo](#funcionalidades-do-aplicativo)
- [Ferramentas de Desenvolvimento](#ferramentas-de-desenvolvimento)
- [Referências](#referências)
- [Equipe de Desenvolvimento](#equipe-de-desenvolvimento)
<br><br><br>

<img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=440&size=22&pause=1000&color=38F77CFF&center=false&vCenter=false&repeat=false&width=435&lines=Introdução" alt="Typing SVG" /></a>
## Apresentação do Projeto: Desenvolvimento de Aplicativo sobre Coleta Seletiva de Óleo

### Contexto Inicial
A crescente produção de resíduos, especialmente de óleo de cozinha usado, tem causado impactos negativos significativos no meio ambiente. Quando descartado de forma inadequada, o óleo usado pode contaminar grandes volumes de água, prejudicar a vida aquática e sobrecarregar os sistemas de tratamento de esgoto. Apesar de existirem iniciativas de reciclagem, muitos consumidores desconhecem os procedimentos corretos para armazenar e entregar o óleo usado. Isso cria a necessidade de ferramentas que facilitem a conscientização, a logística e a reciclagem de forma eficiente.
<br><br><br>

<img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=440&size=22&pause=1000&color=38F77CFF&center=false&vCenter=false&repeat=false&width=435&lines=Buscando um Problema" alt="Typing SVG" /></a>
## Problema Encontrado
O descarte inadequado do óleo de cozinha é uma prática comum devido à falta de informação e acesso a alternativas viáveis. Entre os principais problemas identificados estão:

   - **Falta de conscientização**: Muitos consumidores não entendem os impactos ambientais do descarte incorreto ou os benefícios da reciclagem do óleo.
   - **Dificuldade no armazenamento e separação**: Não existem diretrizes claras ou práticas fáceis para armazenar o óleo usado de forma segura.
   - **Falta de pontos de coleta acessíveis**: Em várias regiões, a ausência de locais próximos para descarte dificulta a adesão à reciclagem.
   - **Baixa visibilidade de incentivos**: Programas de recompensa por reciclagem são pouco divulgados, desmotivando a participação ativa da população.

Esses fatores contribuem para que toneladas de óleo sejam descartadas diretamente no ambiente, agravando os problemas ecológicos e sociais.
<br><br><br>


<img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=440&size=22&pause=1000&color=38F77CFF&center=false&vCenter=false&repeat=false&width=435&lines=Encontrando a Solução" alt="Typing SVG" /></a>
## Nossa Solução
O projeto propõe o desenvolvimento de um aplicativo sobre **coleta seletiva de óleo**, que tem como objetivo principal educar, facilitar e incentivar a reciclagem do óleo de cozinha usado. Nossa solução oferece:

### 1. Educação Ambiental Interativa:
   - Informações sobre o impacto ambiental do descarte inadequado.
   - Dicas práticas sobre como armazenar o óleo usado de forma segura.

### 2. Mapa de Pontos de Coleta: 
   - Localização de pontos de coleta seletiva próximos, com rotas e horários disponíveis.
   - Integração com notificações para lembrar os usuários de entregar o óleo acumulado.

### 3. Sistema de Gamificação e Recompensas:
   - Ranking de usuários que reciclam mais, promovendo uma competição saudável.
   - Prêmios e incentivos, como descontos ou vale-presentes, para os usuários mais engajados.

### 4. Facilidade na Comunicação:
   - Plataforma para se conectar com cooperativas e recicladores locais, promovendo uma economia circular sustentável.

### 5. Impacto Social e Ambiental:
   - Redução da poluição hídrica e dos impactos ambientais do descarte inadequado.
   - Estímulo à conscientização e à construção de hábitos mais sustentáveis.

Nosso aplicativo será uma ferramenta prática e educativa, que combina tecnologia, gamificação e conscientização para transformar o descarte do óleo em uma oportunidade de cuidar do planeta.
<br><br><br>

<img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=440&size=22&pause=1000&color=38F77CFF&center=false&vCenter=false&repeat=false&width=435&lines=Nossa Prototipagem" alt="Typing SVG" /></a>
## Protótipos
Aqui vai a descrição dos protótipos.
<br><br><br>

<img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=440&size=22&pause=1000&color=38F77CFF&center=false&vCenter=false&repeat=false&width=435&lines=Diagramas" alt="Typing SVG" /></a>
## Diagramas

### Diagrama de Classe:
```mermaid
classDiagram
    class Usuario {
      +String cpf PK
      +String nome
      +String email UNIQUE
      +String senha
      +int id_endereco FK
      +int id_pontuacao FK
      +int id_reciclado FK
    }

    class Endereco {
      +int id_endereco PK
      +String cep
      +String rua
      +String bairro
      +String numero
      +Decimal longitude
      +Decimal latitude
    }

    class UsuarioColetor {
      +String cpf PK
      +String nome
      +String email UNIQUE
      +String senha
      +String tipo
      +int id_coletado FK
      +int id_pontuacao FK
    }

    class Reciclado {
      +int id_reciclado PK
      +Double qtd_oleo
      +String cpf FK
    }

    class Pontuacao {
      +int id_pontuacao PK
      +int qtd_dias
      +Double pontuacaoOleo
      +Double pontuacaoVidro
      +String nivel
      +String cpf FK UNIQUE
    }

    class Coletado {
      +int id_coletado PK
      +Double qtd_oleo
      +Date data
      +String cpf FK
    }

    class IniciarColeta {
      +int id_iniciarColeta PK
      +Date data
      +Time hora
    }

    Usuario --> Endereco : "id_endereco"
    Usuario --> Pontuacao : "id_pontuacao"
    Usuario --> Reciclado : "id_reciclado"
    UsuarioColetor --> Coletado : "id_coletado"
    UsuarioColetor --> Pontuacao : "id_pontuacao"
    Reciclado --> Usuario : "cpf"
    Pontuacao --> Usuario : "cpf"
    Coletado --> UsuarioColetor : "cpf"

```
<br><br>
### Diagrama de Fluxo
``` mermaid

flowchart TD
    subgraph LoginCadastro
        A[Login] --> B{Usuário cadastrado?}
        B -- Sim --> C[Home]
        B -- Não --> D[Cadastro]
        D --> E{Escolher tipo de usuário}
        E -- Usuário comum --> C
        E -- Coletor --> F[Home - Coletor]
    end

    subgraph HomeUsuario [Home - Usuário]
        C --> G[Realizar Coleta]
        C --> H[Perfil]
        C --> I[Histórico]
        C --> J[Prêmios]
        G --> K{Escolher tipo de coleta}
        K -- Óleo usado --> L[Coleta de Óleo]
        K -- Eletrônicos --> M[Coleta de Eletrônicos]
        M --> N[Inserir requisitos do eletrônico]
        J --> O[Prêmios Óleo]
        J --> P[Prêmios Eletrônicos]
    end

    subgraph HomeColetor [Home - Coletor]
        F --> Q[Acessar Mapa]
        F --> R[Iniciar Coleta]
        F --> S[Ver Casas Disponíveis]
        S --> T[Visualizar itens da casa]
    end

```
<br><br>
### Diagrama de Uso:
``` mermaid
flowchart TD
    subgraph Usuario [Usuário]
        A1[Login]
        A2[Cadastro]
        A3[Visualizar Home]
        A4[Visualizar Perfil]
        A5[Visualizar Histórico]
        A6[Visualizar Prêmios]
        A7[Realizar Coleta]
        A7 --> A8[Escolher Tipo de Coleta]
        A8 --> A9[Coleta de Óleo Usado]
        A8 --> A10[Coleta de Eletrônicos]
        A10 --> A11[Inserir Requisitos]
    end

    subgraph Coletor [Coletor]
        B1[Login]
        B2[Cadastro]
        B3[Visualizar Home]
        B4[Visualizar Perfil]
        B5[Visualizar Histórico]
        B6[Visualizar Prêmios]
        B7[Acessar Mapa]
        B8[Iniciar Coleta]
        B9[Ver Casas Disponíveis]
        B9 --> B10[Visualizar Itens da Casa]
    end

```

<br><br><br>

<img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=440&size=22&pause=1000&color=38F77CFF&center=false&vCenter=false&repeat=false&width=435&lines=Aplicativo Funcionando" alt="Typing SVG" /></a>
## Funcionalidades do Aplicativo
<details>

<summary> Cadastro de Usuário </summary>

# Cadastro de Novo Usuário

Esta funcionalidade permite cadastrar novos usuários no sistema com informações adicionais como nome e CPF. A implementação inclui validação de campos na interface do usuário e tratamento de erros durante a criação do usuário e o armazenamento de dados no Firebase.

---

## Validação de Campos

Antes de enviar os dados, é realizada uma validação para garantir que todos os campos obrigatórios estejam preenchidos corretamente. 

### Validações Implementadas
1. **Nome:** Não pode estar vazio.
2. **Email:** Não pode estar vazio e deve ser um formato válido.
3. **Senha:** Deve conter pelo menos 6 caracteres.
4. **Confirmação de Senha:** Deve corresponder à senha informada.
5. **CPF:** Não pode estar vazio e deve existir.

Caso algum campo não seja válido, uma mensagem de erro é exibida, orientando o usuário a corrigir o problema.

---

## Tratamento de Erros com `try-catch`

A lógica de cadastro utiliza um bloco `try-catch` para tratar erros durante o processo de registro. Isso garante que, caso ocorra uma falha, o sistema não trave e o erro possa ser identificado e exibido.

### Fluxo no Bloco `try`
1. **Criação do Usuário:** Os dados de autenticação são enviados ao Firebase Authentication.
2. **Armazenamento no Firestore:** Após a criação bem-sucedida do usuário, as informações adicionais (nome, CPF, email, data de criação) são salvas no Firestore.

### No Bloco `catch`
- Caso ocorra um erro em qualquer etapa (autenticação ou armazenamento), o erro é capturado e registrado no console para depuração.
- Um retorno `null` é enviado para indicar falha no processo.
- FirebaseAuthException: Erros relacionados ao Firebase Authentication, como email já cadastrado ou senha inválida.
- FirestoreException: Erros relacionados ao armazenamento de dados no Firestore.
- Outros Erros Genéricos: Erros inesperados são tratados e registrados para análise.

</details>


<details>

<summary> Login </summary>

# Login
Este código implementa a funcionalidade de login com Firebase Authentication e Firestore. Além disso, determina a página para onde o usuário será redirecionado após o login.

1. Entrada de Dados: 
O usuário fornece email e senha nos campos correspondentes.

2. Validação: 
Os campos de entrada possuem validação para garantir que não estejam vazios.

3. Autenticação:
O método _authService.signInWithEmail realiza a autenticação com Firebase Authentication.

Caso o login seja bem-sucedido, o objeto User contendo informações do usuário autenticado é retornado.

- Caso o campo imagem do firestore do usuário esteja vazio ou seja null, o usuário é redirecionado para a página de configuração de ícone (SetIconScreen). Isso força o usuário a selecionar um ícone antes de acessar outras funcionalidades.
- Caso o campo imagem tenha um valor válido, o usuário é redirecionado diretamente para a página inicial (HomePage)

**Outros Pontos:**
1. CustomTextField:
Um componente reutilizável para campos de entrada com validação e personalização visual.

2. GradientButton:
Um botão com estilo de gradiente e bordas arredondadas, reutilizável em diferentes telas.

</details>


<details>

<summary> Seleção de Ícone </summary>

# Tela de Ícones
O código implementa a funcionalidade de permitir que o usuário selecione um ícone e salve essa escolha no banco de dados Firestore, com as seguintes etapas:

1. Exibição das Opções de Ícones:
Uma lista de URLs é usada para exibir os ícones disponíveis.
O índice do ícone selecionado é armazenado na variável selectedIndex.

2. Quando o usuário clica em um ícone, o evento onTap é disparado.
A seleção atualiza o estado (setState) para destacar o ícone escolhido.

3. O botão "Confirmar Seleção" só é habilitado se selectedIndex não for null, garantindo que o usuário escolha um ícone antes de prosseguir.

4. Ao confirmar a escolha, o código usa a coleção users no Firestore.
A imagem escolhida é atualizada no documento do usuário identificado por userId.

```dart
await FirebaseFirestore.instance
    .collection('users')
    .doc(widget.userId)
    .update({'imagem': imageUrls[selectedIndex!]});
```

**Pontos Importantes**
1. Validação e Estado:
O botão de confirmação fica desabilitado (null) até que uma escolha válida seja feita.
2. Firebase:
A atualização no Firestore é feita de forma assíncrona(async), garantindo que a operação seja concluída antes de navegar para a próxima tela.

</details>


<details>

<summary> Cadastro de Endereço </summary>

# Cadastro de Endereço
O código a seguir é da página onde o usuário pode cadastrar um endereço, utilizando o `CEP` para buscar informações como rua e bairro através da `API ViaCEP`. Após o preenchimento, os dados são salvos no Firestore na subcoleção endereco dentro do documento do usuário autenticado no Firebase Authentication.

1. Busca pelo CEP:
Utiliza a API ViaCEP para buscar endereço pelo CEP fornecido.
Preenche automaticamente os campos "Rua" e "Bairro".

2. Validação de Campos:
Valida se os campos estão preenchidos corretamente (CEP com 8 dígitos, rua, bairro e número não vazios).

3. Salvar no Firestore:
Salva os dados do endereço na subcoleção endereco do usuário autenticado.

4. Mensagens de Erro e Sucesso:
Exibe mensagens claras de erro (como CEP inválido ou falha na conexão) e confirmações de sucesso após salvar.

</details>


<details>

<summary> Cadastro de Itens </summary>

# Cadastro de óleo no aplicativo
A funcionalidade de cadastro de óleo permite que usuários registrem a quantidade de óleo reciclado no sistema. Além disso, ela verifica se o usuário possui um endereço cadastrado antes de concluir a operação. Caso não tenha, um diálogo é exibido para orientar o usuário a cadastrar um endereço.
<br><br>
## Fluxo da Funcionalidade:
<br>

### 1. Incremento/Decremento da Quantidade de Óleo:
   - O usuário pode ajustar a quantidade de óleo a ser reciclado em incrementos ou decrementos de 500ml.
<br>

### 2. Verificação de Endereço:
   - Antes de registrar o óleo reciclado, o sistema verifica se o usuário possui um endereço cadastrado.
     
   - Caso não haja um endereço cadastrado, um diálogo é exibido com duas opções:
     
     - **Cadastrar Endereço**: Redireciona para a página de cadastro de endereço.
     - **Voltar**: Fecha o diálogo, permitindo que o usuário volte à tela anterior.
<br>

### 3. Registro dos Dados:
   - Os dados são armazenados na subcoleção reciclado no Firestore, com as seguintes informações:
     - Quantidade de óleo reciclado (**qtd**)
     - Tipo de óleo reciclado (**tipo**)
     - Data e hora do registro (**timestamp**)
     - Status do registro (**status**)
   - Após o registro, o ID do documento gerado automaticamente é adicionado ao próprio documento.
<br>

### 4. Feedback ao Usuário:
   - Em caso de sucesso, é exibida uma mensagem de confirmação via **SnackBar** e o usuário é redirecionado para a tela inicial.
   - Em caso de erro, uma mensagem apropriada é exibida ao usuário.
<br><br>

## Estrutura do Código

### Classe: OilRegisterControllers
Responsável por gerenciar a lógica do registro de óleo reciclado.

### Métodos Principais:
#### 1. increment()
   - **Descrição**: Incrementa a quantidade de óleo reciclado em 500ml.
   - **Retorno**: Atualiza a variável _oilAmount.

#### 2. decrement()
   - **Descrição**: Decrementa a quantidade de óleo reciclado em 500ml, garantindo que o valor não fique negativo.
   - **Retorno**: Atualiza a variável _oilAmount.

#### 3. getOilAmount()
   - **Descrição**: Retorna a quantidade atual de óleo reciclado.
   - **Retorno**: Inteiro representando a quantidade em mililitros.



</details>

<details>

<summary> Traçar Rotas </summary>

# Traço de rotas no aplicativo com Google Maps
A funcionalidade de traço de rotas permite que o coletor identifique os pontos de coleta que estão mais próximos dele com base na sua localização atual. Além disso, ela insere abaixo do mapa algumas informações dos usuários do qual o coletor está indo buscar o óleo em formato de cards.


<br><br>
## Fluxo da Funcionalidade:
<br>

### 1. Exibição:
   - Exibir locais de interesse (como endereços de reciclagem) em um mapa interativo.
<br>

### 2. Rotas:
   - Traçar rotas entre os pontos utilizando a API de Direções do Google Maps.
     
   - Mostrar a distância total da rota calculada.

   - Indicar locais mais próximos do usuário com base em sua localização atual.
<br><br>

## Principais recursos:

**Google Maps Directions API:** Para traçar rotas e calcular distâncias. <br>
**Geolocator**: Para obter a localização atual do dispositivo. <br>
**Flutter Map**: Para renderizar o mapa interativo e mostrar pontos/rotas. <br>
**Cloud Firestore**: Para buscar locais (endereços) salvos no banco de dados. <br>
**Geocoding API**: Para converter endereços em coordenadas geográficas (latitude e longitude). <br>
<br><br>

## Estrutura do Código

### 1. Permissões de Localização
   - O método **_checkLocationPermission** solicita permissões ao usuário para acessar sua localização, verificando também se o serviço de localização está ativo no dispositivo.

### 2. Localização Atual do Usuário
   - O método **_updateLocations** atualiza a posição atual no mapa e a adiciona à lista de locais monitorados.
   - A localização é obtida dinamicamente através do Geolocator.

### 3. Carregamento de Locais do Firestore
   - O método **_loadLocationsAndRoutes** busca dados de locais de reciclagem armazenados no Firestore:
      - Dados de endereço são convertidos em coordenadas geográficas usando a API de Geocodificação.
      - Os locais são adicionados a uma lista para serem exibidos no mapa.

### 4. Traçar Rotas no Google Maps
   - O método **_fetchRoutePointsForAllLocations** faz requisições à API de Direções do Google Maps para traçar rotas entre os pontos:
      - Ponto de origem: Localização atual ou primeiro ponto na lista.
      - Destino: Último ponto na lista.
      - Pontos intermediários: Locais no meio da lista.
      - O polígono (rota) é decodificado e desenhado no mapa usando PolylineLayer.

### 5. Cálculo de Distância Total
   - O método **_calculateDistance** utiliza a fórmula de Haversine para calcular a distância entre dois pontos de latitude/longitude.
   - O total das distâncias entre os pontos consecutivos é calculado.
</details>


<details>

<summary> Ranking </summary>

# Sistema de Pontuação e Ranking
O sistema de ranking é responsável por organizar e exibir os usuários de acordo com sua pontuação de experiência (XP), obtida através de atividades concluídas relacionadas à reciclagem. A funcionalidade inclui:
   - Identificação e ordenação dos usuários com base no XP acumulado.
   - Destaque visual para os três primeiros colocados (pódio).
   - Exibição de prêmios para os melhores colocados, incentivando o engajamento.
<br><br>
## Fluxo da Funcionalidade:
<br>

### 1. Carregamento dos Dados
   - Os dados dos usuários são extraídos da coleção users no **Firebase Firestore**.
   - Para cada usuário, é feita a soma do XP de atividades concluídas presentes na subcoleção reciclado.
   - Usuários são ordenados em ordem decrescente de XP.
<br>

### 2. Exibição no Ranking
   - **Top 3**: Os três primeiros usuários são exibidos em destaque no formato de um pódio.
   - **Resto do Ranking**: Demais usuários aparecem em uma lista organizada e estilizada.
   - Dados apresentados: Nome do usuário, foto de perfil e quantidade de XP.
<br>

### 3. Navegação:
   - O ranking faz parte de um sistema de abas controlado por uma barra de navegação inferior.
   - Ao trocar de aba, a página correspondente é exibida.
<br>

### 4. Botão "Mais Informações"
   - Exibe um diálogo modal com detalhes dos prêmios oferecidos para os cinco primeiros colocados.
<br><br>

## Estrutura do Código

### 1. Classe Principal
**Classe**: RankingPage <br>
**Estado**: _RankingPageState <br>
Controla a inicialização, carregamento e organização dos dados para o ranking.

## 2. Carregamento dos Dados
**Método**: fetchUserXpData() <br>
Responsabilidade: Busca os dados no **Firestore**, calcula o XP acumulado e ordena os usuários por pontuação.

## 3. Construção da Interface
**Método Principal**: build(BuildContext context) <br>
Usa um FutureBuilder para aguardar os dados de XP. <br>
Exibe as seções: pódio e lista de usuários restantes.

## 4. Destaque dos Três Primeiros
**Método**: _buildTopThreeSection() <br>
Monta o pódio com estilos diferenciados para os três primeiros colocados.

## 5. Lista dos Demais Usuários
**Método**: _buildRemainingRanking() <br>
Renderiza os usuários do 4º lugar em diante, com informações em um estilo de lista personalizada.

## 6. Diálogo de Prêmios
**Método**: _showRewardsDialog() <br>
Apresenta uma mensagem animada com os prêmios para os 5 melhores.
</details>
<br><br><br>

<img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=440&size=22&pause=1000&color=38F77CFF&center=false&vCenter=false&repeat=false&width=435&lines=Utilização de Ferramentas de Trabalho" alt="Typing SVG" /></a>
## Ferramentas de Desenvolvimento
 <p>  
      
  <table>
  <thead>
    <tr>
      <th> Linguagens </th>
      <th> Frameworks </th>
      <th> Outros </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td align="center"> <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart Badge"/> </td>
       <td align="center"> <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter Badge" style="width: 100%"/> </td>
        <td align="center"> <img src="https://img.shields.io/badge/Firebase-000?style=for-the-badge&logo=firebase&logoColor=ffca28" alt="Firebase Badge"/> </td>
    </tr>
     <tr>
         <td align="center"> </td>
         <td align="center">  </td>
         <td align="center"> <img src="https://img.shields.io/badge/Visual_Studio_Code-0078D4?style=for-the-badge&logo=visual%20studio%20code&logoColor=white" alt="VScode Badge"/> </td>
      </tr>
    <tr>
      <td align="center"> </td>
        <td align="center"> </td>
        <td align="center"> <img src="https://img.shields.io/badge/GIT-E44C30?style=for-the-badge&logo=git&logoColor=white" alt="Git Badge"/> </td>
    </tr>
    <tr>
      <td align="center">  </td>
      <td align="center"> </td>
       <td align="center"> <img src="https://img.shields.io/badge/Figma-696969?style=for-the-badge&logo=figma&logoColor=figma"/> </td>
    </tr>
  </tbody>
</table>
   </p>
</p>
<br><br><br>

<img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=440&size=22&pause=1000&color=38F77CFF&center=false&vCenter=false&repeat=false&width=435&lines=Fontes de Pesquisa do Projeto" alt="Typing SVG" /></a>
## Referências

* ### Fontes de Pesquisa para Desenvolvimento do Problema:
    - [G1 - Notícia sobre acúmulo de lixo e mato alto na praça de Limeira](https://g1.globo.com/sp/piracicaba-regiao/noticia/2023/12/25/sem-manutencao-praca-de-limeira-tem-mato-alto-acumulo-de-lixo-e-gera-transtornos-a-moradores.ghtml)
    - [Prefeitura faz Contrato Emergencial para limpeza pública](https://diariodejustica.com.br/prefeitura-de-limeira-faz-contrato-emergencial-de-r-209-milhoes-para-limpeza-publica/)
    - [Resíduos no Brasil não são reaproveitados](https://g1.globo.com/jornal-nacional/noticia/2023/05/17/dia-mundial-da-reciclagem-96percent-dos-residuos-produzidos-no-brasil-nao-sao-reaproveitados.ghtml)
    - [Vídeo sobre a Coleta Seletiva de Limeira](https://www.facebook.com/prefeituralimeira/videos/a-coleta-seletiva-realizada-em-limeira-percorre-v%C3%A1rias-regi%C3%B5es-da-cidade-o-servi/754470765802787/)

* ### IA's Utilizadas:
    - [ChatGPT 3.5](https://chat.openai.com/)
    - [Claude AI](https://claude.ai/login?returnTo=%2F%3F)
    - [Gama App](https://gamma.app/pt-br)
    - [Bing - Image Creator](https://www.bing.com/images/create)
 
* ### UX/UI:
  - [Figma](https://www.figma.com/)
  
<br><br><br>

<img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=440&size=22&pause=1000&color=38F77CFF&center=false&vCenter=false&repeat=false&width=435&lines=Desenvolvedores" alt="Typing SVG" /></a>
## Equipe de Desenvolvimento
<div align=center>
  <table style="width: 100%">
    <tbody>
      <tr align=center>
        <th><strong> Heitor Rodrigo de Melo Silva </br> Hunter7210 </strong></th>
        <th><strong> João Victor de Lima </br> JoaovlLima </strong></th>
        <th><strong> Rafael Souza de Moura </br> rafaelmoura23</strong></th>
         <th><strong> Vinícius Granço Feitoza </br> epicestudar </strong></th>
      </tr>
      <tr align=center>
        <td>
          <a href="https://github.com/Hunter7210">
            <img width="250" height="200" style="border-radius: 50%;" src="https://avatars.githubusercontent.com/Hunter7210">
          </a>
        </td>
        <td>
          <a href="https://github.com/JoaovlLima">
            <img width="250" height="200" style="border-radius: 50%;" src="https://avatars.githubusercontent.com/JoaovlLima">
          </a>
        </td>
         <td>
          <a href="https://github.com/rafaelmoura23">
            <img width="250" height="200" style="border-radius: 50%;" src="https://avatars.githubusercontent.com/rafaelmoura23">
          </a>
        </td>
         <td>
          <a href="https://github.com/epicestudar">
            <img width="250" height="200" style="border-radius: 50%;" src="https://avatars.githubusercontent.com/epicestudar">
          </a>
        </td>
      </tr>
    </tbody>

  </table>
</div>
