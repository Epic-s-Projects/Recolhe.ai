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
