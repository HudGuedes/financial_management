# Financial Management API

API REST para gestão financeira e administrativa voltada ao setor de educação, com foco em cobranças, recebimentos e organização de fluxos financeiros de responsáveis.

## Tecnologias Utilizadas

- **Ruby**: 3.0.7
- **Rails**: 6.1.3.2
- **Banco de Dados**: PostgreSQL
- **Arquitetura**: API REST

## Estrutura do Projeto

A aplicação gerencia os seguintes conceitos:

- **Guardians** (Responsáveis Financeiros): Pessoas responsáveis pelos pagamentos
- **Cost Centers** (Centros de Custo): Categorias de cobrança (ex: MATRÍCULA, MENSALIDADE, MATERIAL)
- **Payment Plans** (Planos de Pagamento): Planos que vinculam responsáveis a centros de custo
- **Charges** (Cobranças): Parcelas de pagamento com datas de vencimento
- **Payments** (Pagamentos): Registros de pagamentos realizados

## Pré-requisitos

- Ruby 3.0.7
- PostgreSQL instalado e rodando
- Bundler
- **Ferramenta de requisições HTTP**: Postman, Insomnia, Thunder Client, ou similar

## Configuração do Ambiente

### 1. Clone o repositório e instale as dependências

```bash
cd financial_management
bundle install
```

### 2. Configure o banco de dados

O arquivo `config/database.yml` já está configurado para PostgreSQL. Se necessário, ajuste as credenciais:

```yaml
development:
  adapter: postgresql
  encoding: unicode
  database: financial_management_development
  pool: 5
  # username: seu_usuario
  # password: sua_senha
  # host: localhost
```

### 3. Crie o banco de dados e execute as migrations

```bash
bundle exec rails db:create
bundle exec rails db:migrate
```

### 4. Inicie o servidor

```bash
bundle exec rails server
```

A API estará disponível em `http://localhost:3000`

## Testando a API com Postman/Insomnia

Importe as requisições abaixo na sua ferramenta preferida (Postman, Insomnia, Thunder Client, etc).

### Fluxo Inicial: Criando Dados do Zero

Siga esta ordem para criar os dados iniciais e testar a aplicação:

#### 1. Criar Centros de Custo

Primeiro, crie os centros de custo disponíveis:

**POST** `http://localhost:3000/cost_centers`

```json
{
  "cost_center": {
    "name": "Matrícula",
    "code": "MATRICULA",
    "description": "Taxa de matrícula anual"
  }
}
```

**POST** `http://localhost:3000/cost_centers`

```json
{
  "cost_center": {
    "name": "Mensalidade",
    "code": "MENSALIDADE",
    "description": "Mensalidade escolar"
  }
}
```

**POST** `http://localhost:3000/cost_centers`

```json
{
  "cost_center": {
    "name": "Material Escolar",
    "code": "MATERIAL",
    "description": "Material didático"
  }
}
```

#### 2. Criar Responsáveis Financeiros

Agora crie os responsáveis que farão os pagamentos:

**POST** `http://localhost:3000/guardians`

```json
{
  "guardian": {
    "name": "Maria Santos",
    "cpf": "123.456.789-00",
    "email": "maria@email.com",
    "phone": "(11) 98888-1111"
  }
}
```

**POST** `http://localhost:3000/guardians`

```json
{
  "guardian": {
    "name": "João Silva",
    "cpf": "987.654.321-00",
    "email": "joao@email.com",
    "phone": "(11) 97777-2222"
  }
}
```

#### 3. Criar Plano de Pagamento com Cobranças

Com os IDs dos responsáveis e centros de custo, crie planos de pagamento:

**POST** `http://localhost:3000/payment_plans`

```json
{
  "payment_plan": {
    "guardian_id": 1,
    "cost_center_id": 2,
    "charges_attributes": [
      {
        "amount": 800.00,
        "due_date": "2025-02-10",
        "payment_method": "boleto"
      },
      {
        "amount": 800.00,
        "due_date": "2025-03-10",
        "payment_method": "pix"
      },
      {
        "amount": 800.00,
        "due_date": "2025-04-10",
        "payment_method": "boleto"
      }
    ]
  }
}
```

#### 4. Consultar Dados Criados

Verifique os dados:

**GET** `http://localhost:3000/guardians/1/charges`
- Visualize todas as cobranças de um responsável

**GET** `http://localhost:3000/guardians/1/payment_plans`
- Visualize todos os planos de um responsável

**GET** `http://localhost:3000/payment_plans/1/total`
- Obtenha o valor total do plano

**GET** `http://localhost:3000/guardians/1/charges/count`
- Quantidade de cobranças do responsável

#### 5. Registrar um Pagamento

Para registrar que uma cobrança foi paga:

**POST** `http://localhost:3000/charges/1/payments`

```json
{
  "payment": {
    "amount": 800.00,
    "payment_date": "2025-01-17",
    "notes": "Pagamento realizado via transferência bancária"
  }
}
```

Após isso, a cobrança terá seu status alterado para "paga".

## Endpoints Completos da API

### Responsáveis Financeiros (Guardians)

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/guardians` | Listar todos os responsáveis |
| GET | `/guardians/:id` | Buscar responsável específico |
| POST | `/guardians` | Criar novo responsável |
| GET | `/guardians/:id/payment_plans` | Listar planos de um responsável |
| GET | `/guardians/:id/charges` | Listar cobranças de um responsável |
| GET | `/guardians/:id/charges/count` | Quantidade de cobranças |

### Centros de Custo (Cost Centers)

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/cost_centers` | Listar todos os centros de custo |
| GET | `/cost_centers/:id` | Buscar centro específico |
| POST | `/cost_centers` | Criar novo centro de custo |
| PUT/PATCH | `/cost_centers/:id` | Atualizar centro de custo |
| DELETE | `/cost_centers/:id` | Deletar centro de custo |

### Planos de Pagamento (Payment Plans)

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/payment_plans` | Listar todos os planos |
| GET | `/payment_plans/:id` | Buscar plano específico |
| POST | `/payment_plans` | Criar plano com cobranças |
| GET | `/payment_plans/:id/total` | Valor total do plano |

### Cobranças (Charges)

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/charges` | Listar todas as cobranças |
| GET | `/charges/:id` | Buscar cobrança específica |
| POST | `/charges/:id/payments` | Registrar pagamento |

## Regras de Negócio

### Status da Cobrança

- **emitida**: Cobrança criada, aguardando pagamento
- **paga**: Cobrança já foi paga
- **cancelada**: Cobrança cancelada
- **vencida** (calculado): Quando `due_date < data_atual` e status é "emitida"

### Métodos de Pagamento

- **boleto**: Gera código de boleto simulado automaticamente
- **pix**: Gera código PIX simulado automaticamente

### Validações

- Não é permitido registrar pagamento em cobrança cancelada
- O valor total do plano é calculado automaticamente como a soma das cobranças
- Códigos de pagamento são gerados automaticamente ao criar uma cobrança
- CPF do responsável deve ser único

## Estrutura do Banco de Dados

```
guardians
  - id
  - name
  - cpf (unique)
  - email
  - phone

cost_centers
  - id
  - name
  - code (unique)
  - description

payment_plans
  - id
  - guardian_id (FK)
  - cost_center_id (FK)
  - total_amount

charges
  - id
  - payment_plan_id (FK)
  - amount
  - due_date
  - payment_method (enum: boleto, pix)
  - status (enum: emitida, paga, cancelada)
  - payment_code (auto-generated, unique)

payments
  - id
  - charge_id (FK)
  - amount
  - payment_date
  - notes
```

## Cenários de Teste Sugeridos

### Cenário 1: Mensalidade Escolar Anual

1. Criar centro de custo "Mensalidade"
2. Criar responsável
3. Criar plano com 12 cobranças mensais de R$ 800,00
4. Registrar pagamento das primeiras parcelas
5. Consultar status das cobranças (pagas, pendentes, vencidas)

### Cenário 2: Matrícula + Material

1. Criar centros de custo "Matrícula" e "Material"
2. Criar responsável
3. Criar plano de matrícula (parcela única de R$ 1.500,00)
4. Criar plano de material (3 parcelas de R$ 300,00)
5. Consultar total de cobranças do responsável

### Cenário 3: Múltiplos Responsáveis

1. Criar 3 centros de custo diferentes
2. Criar 3 responsáveis
3. Criar planos variados para cada responsável
4. Testar filtros e consultas por responsável

## Diferenciais Implementados

- **API de Centros de Custo Customizáveis**: Endpoints completos para criar, listar, atualizar e deletar centros de custo
- **Cálculo automático de status "vencida"**: Calculado dinamicamente nas consultas
- **Geração automática de códigos de pagamento**: Para boleto e PIX
- **Validações completas**: Em todos os modelos
- **Nested Attributes**: Criação de planos com múltiplas cobranças em uma única requisição

### Erro de permissões

Crie um usuário PostgreSQL ou ajuste as credenciais em `config/database.yml`

## Autor

Desenvolvido como teste técnico para a Kedu
