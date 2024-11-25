# Recolhe.ai
repositório destinado para o projeto final do SENAI

<img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=440&size=22&pause=1000&color=9c20f5&center=false&vCenter=false&repeat=false&width=435&lines=Diagrama de Classe" alt="Typing SVG" />

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
      +int id_eletronico FK
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
      +int id_eletronico FK
      +Date data
      +String cpf FK
    }

    class Eletronico {
      +int id_eletronico PK
      +Double qtd
      +String tipo
      +String img
      +Decimal altura
      +Decimal comprimento
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
    Reciclado --> Eletronico : "id_eletronico"
    Reciclado --> Usuario : "cpf"
    Pontuacao --> Usuario : "cpf"
    Coletado --> Eletronico : "id_eletronico"
    Coletado --> UsuarioColetor : "cpf"

```
<br><br><br><br><br>

<img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=440&size=22&pause=1000&color=9c20f5&center=false&vCenter=false&repeat=false&width=435&lines=Diagrama de Fluxo" alt="Typing SVG" />

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
<br><br><br><br><br>

<img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=440&size=22&pause=1000&color=9c20f5&center=false&vCenter=false&repeat=false&width=435&lines=Diagrama de Uso" alt="Typing SVG" />

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


# Funcionalidades

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
Seleção do Ícone:

2. Quando o usuário clica em um ícone, o evento onTap é disparado.
A seleção atualiza o estado (setState) para destacar o ícone escolhido.
Validação da Escolha:

3. O botão "Confirmar Seleção" só é habilitado se selectedIndex não for null, garantindo que o usuário escolha um ícone antes de prosseguir.
Atualização no Firestore:

4. Ao confirmar a escolha, o código usa a coleção users no Firestore.
A imagem escolhida é atualizada no documento do usuário identificado por userId:

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

# Cadastrar Itens(Óleo e/ou Eletrônico) no Firebase

</details>

<details>

<summary> Traçar Rotas </summary>

# Traçar Rotas entre pontos(flutter_osm_plugin 1.3.5)

  - https://www.youtube.com/watch?v=1tG93RjDP-E

</details>


<details>

<summary> Pontuação </summary>

# Pontuação

</details>

