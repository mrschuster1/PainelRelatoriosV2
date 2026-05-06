# Painel de Relatórios V2

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Wails](https://img.shields.io/badge/built%20with-Wails-red.svg)
![React](https://img.shields.io/badge/frontend-React-61dafb.svg)
![Go](https://img.shields.io/badge/backend-Go-00add8.svg)

Um painel de relatórios moderno e profissional, desenvolvido com **Wails**, **Go** e **React (TypeScript)**. Projetado para oferecer uma experiência de análise de dados fluida, com foco em performance, estética premium e ferramentas avançadas de exportação.

## 🚀 Funcionalidades

- **DataGrid Avançado**: Visualização de grandes volumes de dados com suporte a agrupamento dinâmico.
- **Filtros Inteligentes**: Painel de filtros avançado com suporte a salvamento de presets personalizados.
- **Exportação Premium**:
  - **Excel**: Exportação fiel ao estado do grid, incluindo agrupamentos e formatação.
  - **PDF**: Documentos profissionais com design elegante e pronto para apresentação.
- **Persistência Local**: Configurações e preferências salvas automaticamente em um banco SQLite local.
- **Alta Performance**: Processamento distribuído no backend em Go para garantir fluidez mesmo com muitos registros.
- **Interface Moderna**: UI baseada em princípios de design limpo, com suporte a temas e micro-animações.

## 🛠️ Tecnologias

- **Backend**: [Go](https://golang.org/) (Golang)
- **Framework Desktop**: [Wails v2](https://wails.io/)
- **Frontend**: [React](https://reactjs.org/) + [TypeScript](https://www.typescriptlang.org/)
- **Build Tool**: [Vite](https://vitejs.dev/)
- **Banco de Dados**: 
  - MySQL/MariaDB (Dados Principais)
  - SQLite (Configurações Locais)
- **Estilização**: CSS Moderno (Vanilla)

## 📋 Pré-requisitos

Antes de começar, você precisará ter instalado em sua máquina:
- [Go](https://golang.org/doc/install) (versão 1.21 ou superior)
- [Node.js](https://nodejs.org/) e npm
- [Wails CLI](https://wails.io/docs/gettingstarted/installation)
- Um banco de dados MySQL/MariaDB acessível

## 🔧 Instalação e Configuração

1. **Clone o repositório**:
   ```bash
   git clone https://github.com/mrschuster1/PainelRelatoriosV2.git
   cd PainelRelatoriosV2
   ```

2. **Configuração de Ambiente**:
   - Copie o arquivo `.env.example` para `.env`:
     ```bash
     cp .env.example .env
     ```
   - Edite o arquivo `.env` com as credenciais do seu banco de dados.

3. **Instale as dependências do frontend**:
   ```bash
   cd frontend
   npm install
   cd ..
   ```

## 🚀 Execução

### Modo Desenvolvimento
Para rodar a aplicação em modo de desenvolvimento com hot-reload:
```bash
wails dev
```

### Build para Produção
Para gerar o executável final:
```bash
wails build
```
O executável será gerado na pasta `build/bin`.

## 🤝 Contribuindo

Contribuições são sempre bem-vindas!
1. Faça um Fork do projeto.
2. Crie uma Branch para sua feature (`git checkout -b feature/NovaFeature`).
3. Commit suas mudanças (`git commit -m 'Adicionando nova funcionalidade'`).
4. Push para a Branch (`git push origin feature/NovaFeature`).
5. Abra un Pull Request.

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---
Desenvolvido por [mrschuster1](https://github.com/mrschuster1)
