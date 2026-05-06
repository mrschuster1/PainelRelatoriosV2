-- painel.agendamentos definição

CREATE TABLE `agendamentos` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Cliente` int(11) unsigned NOT NULL DEFAULT '0',
  `Analista` int(11) unsigned NOT NULL DEFAULT '0',
  `Data` date NOT NULL DEFAULT '0000-00-00',
  `HoraInicial` time DEFAULT '00:00:00',
  `HoraFinal` time NOT NULL DEFAULT '00:00:00',
  `Local` varchar(100) DEFAULT NULL,
  `Parecer` longtext,
  `ParecerFinal` longtext,
  `DataReal` date NOT NULL DEFAULT '0000-00-00',
  `HoraIniReal` time NOT NULL DEFAULT '00:00:00',
  `HoraIniFinal` time NOT NULL DEFAULT '00:00:00',
  `Atendimento` int(11) unsigned NOT NULL DEFAULT '0',
  `KmInicial` int(11) unsigned NOT NULL DEFAULT '0',
  `KmFinal` int(11) unsigned NOT NULL DEFAULT '0',
  `Veiculo` varchar(20) NOT NULL DEFAULT 'Moto',
  `Status` char(1) NOT NULL DEFAULT 'A' COMMENT 'A = Aberto / F = Fechado / C = Cancelado',
  `Pessoa` varchar(30) DEFAULT NULL,
  `Tipo` varchar(20) DEFAULT 'Outros',
  `Interno` char(1) NOT NULL DEFAULT 'N',
  `Vinculado` char(1) DEFAULT 'N',
  `VisitaConfirmada` char(1) DEFAULT 'N',
  `GerouAtt` char(1) DEFAULT 'N',
  `Avaliado` char(1) DEFAULT 'N',
  `ItemImplantacao` int(11) NOT NULL DEFAULT '0',
  `HoraCheckIn` time DEFAULT NULL,
  `HoraCheckOut` time DEFAULT NULL,
  `DataCheckIn` date DEFAULT NULL,
  `DataCheckOut` date DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `IdxAgeAtendimento` (`Atendimento`),
  KEY `IdxAgDataReal` (`DataReal`),
  KEY `IdxAgeAttCli` (`Cliente`,`Atendimento`)
) ENGINE=InnoDB AUTO_INCREMENT=342 DEFAULT CHARSET=utf8;


-- painel.aplicacao definição

CREATE TABLE `aplicacao` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Aplicacao` varchar(20) NOT NULL DEFAULT '',
  `Ativa` char(1) NOT NULL DEFAULT 'S',
  `T` char(1) NOT NULL DEFAULT 'S',
  `A` char(1) NOT NULL DEFAULT 'S',
  `G` char(1) NOT NULL DEFAULT 'S',
  `P` char(1) NOT NULL DEFAULT 'S',
  `I` char(1) NOT NULL DEFAULT 'S',
  `F` char(1) NOT NULL DEFAULT 'S',
  `C` char(1) NOT NULL DEFAULT 'S',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;


-- painel.atendimentos definição

CREATE TABLE `atendimentos` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Cliente` int(11) unsigned DEFAULT '0',
  `Pessoa` varchar(30) CHARACTER SET latin1 DEFAULT NULL,
  `Data` date DEFAULT NULL,
  `Hora` time DEFAULT NULL,
  `Categoria` varchar(20) DEFAULT NULL,
  `Historico` longtext,
  `Acao` varchar(20) DEFAULT NULL,
  `UserAbriu` int(11) unsigned DEFAULT '0',
  `UserAtribuido` int(11) unsigned DEFAULT '0',
  `Fechado` char(1) NOT NULL DEFAULT 'N',
  `Prioridade` tinyint(1) NOT NULL DEFAULT '1',
  `Ligacoes` int(11) NOT NULL DEFAULT '1',
  `UserTele` int(11) unsigned NOT NULL DEFAULT '0',
  `BloqueadoPara` int(11) unsigned NOT NULL DEFAULT '0',
  `DataFechamento` date DEFAULT NULL,
  `HoraFechamento` time DEFAULT NULL,
  `Setor` int(11) NOT NULL DEFAULT '0',
  `SPEDPISCOFINS` char(1) DEFAULT 'N',
  `ParticularDe` int(11) NOT NULL DEFAULT '0',
  `ParticularPara` int(11) NOT NULL DEFAULT '0',
  `ParaCelula` int(11) NOT NULL DEFAULT '0',
  `CelulaVinculada` int(11) NOT NULL DEFAULT '0',
  `Aplicacao` varchar(20) NOT NULL DEFAULT '',
  `modulo` varchar(20) NOT NULL DEFAULT '',
  `DataAbertura` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `DataAtribuicao` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `IdxAttCliente` (`Cliente`),
  KEY `IdxAttData` (`Data`)
) ENGINE=InnoDB AUTO_INCREMENT=1466563 DEFAULT CHARSET=utf8;


-- painel.att_analise definição

CREATE TABLE `att_analise` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Agendamento` int(11) DEFAULT NULL,
  `CumpriuHorario` char(1) DEFAULT 'N' COMMENT 'S = Sim / N = Não',
  `FicouPendencias` char(1) DEFAULT 'N' COMMENT 'S = Sim / N = Não',
  `SatisfacaoAnalista` varchar(20) DEFAULT NULL,
  `SatisfacaoSistema` varchar(20) DEFAULT NULL,
  `Parecer` longtext,
  PRIMARY KEY (`Id`),
  KEY `IdxAgendamento` (`Agendamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- painel.categorias definição

CREATE TABLE `categorias` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Categoria` varchar(20) DEFAULT NULL,
  `Ativa` char(1) NOT NULL DEFAULT 'S',
  `T` char(1) NOT NULL DEFAULT 'S',
  `A` char(1) NOT NULL DEFAULT 'S',
  `G` char(1) NOT NULL DEFAULT 'S',
  `P` char(1) NOT NULL DEFAULT 'S',
  `I` char(1) NOT NULL DEFAULT 'S',
  `F` char(1) NOT NULL DEFAULT 'S',
  `C` char(1) NOT NULL DEFAULT 'S',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;


-- painel.celulas definição

CREATE TABLE `celulas` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Celula` varchar(30) DEFAULT NULL,
  `Sistema` int(11) NOT NULL DEFAULT '0',
  `Gestor` int(11) NOT NULL DEFAULT '0',
  `Membros` varchar(250) DEFAULT NULL,
  `Niveis` varchar(250) DEFAULT NULL,
  `Ativa` char(1) NOT NULL DEFAULT 'S',
  `Padrao` char(1) NOT NULL DEFAULT 'N',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;


-- painel.checklist_implantacao definição

CREATE TABLE `checklist_implantacao` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Item` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- painel.cidades definição

CREATE TABLE `cidades` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Cidade` varchar(50) DEFAULT NULL,
  `UF` char(2) DEFAULT NULL,
  `Ativa` char(1) NOT NULL DEFAULT 'S',
  `MetaProspectoDia` int(11) unsigned NOT NULL DEFAULT '10',
  `DiasMaxSemVisita` int(11) unsigned NOT NULL DEFAULT '30',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;


-- painel.cli_anexos definição

CREATE TABLE `cli_anexos` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Cliente` int(11) NOT NULL DEFAULT '0',
  `Nome` varchar(255) DEFAULT NULL,
  `Extensao` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- painel.cli_prospecto definição

CREATE TABLE `cli_prospecto` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `SistemaAtual` varchar(100) DEFAULT NULL,
  `NumLicencas` smallint(6) DEFAULT NULL,
  `Satisfacao` varchar(30) DEFAULT NULL,
  `DadosAdic` longtext,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=6976 DEFAULT CHARSET=utf8;


-- painel.clientes definição

CREATE TABLE `clientes` (
  `Nome` varchar(100) CHARACTER SET latin1 COLLATE latin1_spanish_ci NOT NULL DEFAULT 'Nome do cliente',
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `RazaoSocial` varchar(100) DEFAULT NULL,
  `CpfCnpj` varchar(14) DEFAULT NULL,
  `Telefone` char(13) CHARACTER SET latin1 NOT NULL DEFAULT '(00)0000-0000',
  `Contato` varchar(30) CHARACTER SET latin1 DEFAULT NULL,
  `Unidade` varchar(30) CHARACTER SET latin1 DEFAULT NULL,
  `Sistema` varchar(15) CHARACTER SET latin1 DEFAULT NULL,
  `Analista` varchar(30) DEFAULT NULL,
  `CodAnalista` int(11) NOT NULL DEFAULT '0',
  `NFe` char(1) NOT NULL DEFAULT 'N',
  `SPED` char(1) NOT NULL DEFAULT 'N',
  `Inativo` char(1) NOT NULL DEFAULT 'N',
  `Endereco` varchar(100) DEFAULT NULL,
  `UserCadastro` int(11) DEFAULT NULL,
  `IdClienteSOL` int(11) DEFAULT NULL,
  `DataCadastro` date DEFAULT NULL,
  `Implantacao` char(1) DEFAULT 'N',
  `Interno` char(1) DEFAULT 'N',
  `Prospecto` char(1) DEFAULT 'N',
  `IdProspecto` int(11) NOT NULL DEFAULT '0',
  `Bloqueado` char(1) DEFAULT 'N',
  `ValorCI` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `ValorMA` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `DiaVctoMA` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Faturamento` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `DataCtrIni` date DEFAULT NULL,
  `DataCtrFim` date DEFAULT NULL,
  `ResponsavelContrato` tinyint(3) NOT NULL DEFAULT '-1',
  `Celular` char(13) DEFAULT '(00)0000-0000',
  `NFeS` char(1) NOT NULL DEFAULT 'N',
  `IdContador` int(11) NOT NULL DEFAULT '0',
  `NomeContador` varchar(100) DEFAULT NULL,
  `EMail` varchar(150) DEFAULT NULL,
  `TipoTrib` varchar(100) DEFAULT NULL,
  `SPEDPISCOFINS` char(1) DEFAULT 'N',
  `IndiceMA` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `PercISSQN` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `Parceiro` char(1) DEFAULT 'N',
  `NumeroEndereco` int(11) NOT NULL DEFAULT '0',
  `RamoAtividade` varchar(100) DEFAULT NULL,
  `Bairro` varchar(75) DEFAULT NULL,
  `CxPostal` varchar(10) DEFAULT NULL,
  `CEP` varchar(9) DEFAULT NULL,
  `EndComplemento` varchar(100) DEFAULT NULL,
  `Celula` int(11) NOT NULL DEFAULT '0',
  `responsavel` varchar(50) DEFAULT NULL,
  `modulos` mediumtext,
  `Observacao` longtext,
  PRIMARY KEY (`Id`),
  KEY `idx_cpfcnpj` (`CpfCnpj`)
) ENGINE=InnoDB AUTO_INCREMENT=1010589 DEFAULT CHARSET=utf8;


-- painel.cobranca definição

CREATE TABLE `cobranca` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `IdTitulo` int(11) unsigned NOT NULL DEFAULT '0',
  `Data` date DEFAULT NULL,
  `PrevPagamento` date DEFAULT NULL,
  `Historico` longtext,
  `IdUser` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- painel.comissoes definição

CREATE TABLE `comissoes` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Perfil` varchar(20) DEFAULT NULL,
  `Percentual` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `Valor` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `IdUser` int(11) unsigned NOT NULL DEFAULT '0',
  `IdTitulo` int(11) NOT NULL DEFAULT '0',
  `Data` date DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- painel.config definição

CREATE TABLE `config` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Versao` varchar(15) NOT NULL DEFAULT '0.0.0',
  `GerReceber` int(11) unsigned NOT NULL DEFAULT '0',
  `MetaDia` int(11) unsigned NOT NULL DEFAULT '10',
  `BloqueiaPor` char(1) DEFAULT 'G',
  `BloqueiaUsuario` char(1) DEFAULT 'S',
  `DiasBloqAgendamento` int(11) unsigned NOT NULL DEFAULT '2',
  `DiasBloqAtendimento` int(11) unsigned NOT NULL DEFAULT '2',
  `DiasMaxSemVisita` int(11) unsigned NOT NULL DEFAULT '30',
  `IgnoraBloqueioVisita` char(1) DEFAULT 'S',
  `PastaArquivosClientes` varchar(255) NOT NULL DEFAULT '',
  `RecJuros` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `RecMulta` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `DiasAtt` int(11) unsigned NOT NULL DEFAULT '7',
  `DtUltAtt` date DEFAULT NULL,
  `DiasBck` int(11) unsigned NOT NULL DEFAULT '0',
  `DtUltBck` date DEFAULT NULL,
  `ValorBaseMA` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `EMailFinanc` varchar(150) DEFAULT NULL,
  `NomeEmpresa` varchar(100) DEFAULT NULL,
  `DiasBloqueioCliente` int(11) unsigned NOT NULL DEFAULT '0',
  `SMTPDominio` varchar(100) DEFAULT NULL,
  `SMTPEmail` varchar(150) DEFAULT NULL,
  `SMTPUsuario` varchar(50) DEFAULT NULL,
  `SMTPHost` varchar(100) DEFAULT NULL,
  `SMTPNome` varchar(100) DEFAULT NULL,
  `SMTPSenha` varchar(25) DEFAULT NULL,
  `VlrMinISSQN` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `DiasMaxSPED` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;


-- painel.contadores definição

CREATE TABLE `contadores` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Nome` varchar(100) DEFAULT NULL,
  `PessoaContato` varchar(30) DEFAULT NULL,
  `Telefone` char(13) NOT NULL DEFAULT '(00)0000-0000',
  `Fax` varchar(13) DEFAULT NULL,
  `Celular` varchar(13) DEFAULT NULL,
  `Cidade` varchar(30) DEFAULT NULL,
  `EMail` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;


-- painel.expediente definição

CREATE TABLE `expediente` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Hora` time NOT NULL DEFAULT '00:00:00',
  `HoraAte` time NOT NULL DEFAULT '00:00:00',
  `HoraTarde` time NOT NULL DEFAULT '00:00:00',
  `HoraTardeAte` time NOT NULL DEFAULT '00:00:00',
  `Sabados` char(1) NOT NULL DEFAULT 'N',
  `HoraSabado` time NOT NULL DEFAULT '00:00:00',
  `HoraSabadoAte` time NOT NULL DEFAULT '00:00:00',
  `InicioVigencia` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- painel.feriados definição

CREATE TABLE `feriados` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `DataEspecifica` date DEFAULT NULL,
  `DiaPerpetuo` tinyint(2) NOT NULL DEFAULT '0',
  `MesPerpetuo` tinyint(2) NOT NULL DEFAULT '0',
  `Descricao` varchar(100) DEFAULT NULL,
  `Oficial` char(1) DEFAULT 'N',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;


-- painel.historicos definição

CREATE TABLE `historicos` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Atendimento` int(11) NOT NULL DEFAULT '0',
  `Data` date DEFAULT NULL,
  `Hora` time DEFAULT '00:00:00',
  `HistAcao` varchar(250) DEFAULT NULL,
  `Historico` longtext,
  PRIMARY KEY (`Id`),
  KEY `IdxHistIdAtt` (`Atendimento`)
) ENGINE=InnoDB AUTO_INCREMENT=2157601 DEFAULT CHARSET=utf8;


-- painel.implantacao_itens definição

CREATE TABLE `implantacao_itens` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Descricao` varchar(75) DEFAULT NULL,
  `Indice` int(11) unsigned NOT NULL DEFAULT '0',
  `IndiceAbsoluto` int(11) unsigned NOT NULL DEFAULT '0',
  `IndicePai` int(11) unsigned NOT NULL DEFAULT '0',
  `Horas` int(11) unsigned NOT NULL DEFAULT '0',
  `Roteiro` int(11) unsigned NOT NULL DEFAULT '0',
  `IndicePaiAbsoluto` int(11) unsigned NOT NULL DEFAULT '0',
  `CheckList` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- painel.implantacao_roteiros definição

CREATE TABLE `implantacao_roteiros` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Roteiro` varchar(100) DEFAULT NULL,
  `Perguntas` varchar(250) NOT NULL DEFAULT '0;0',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- painel.implantacoes definição

CREATE TABLE `implantacoes` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Cliente` int(11) NOT NULL DEFAULT '0',
  `Analista` int(11) NOT NULL DEFAULT '0',
  `Roteiro` varchar(100) DEFAULT NULL,
  `PrevisaoHoras` int(11) DEFAULT NULL,
  `PrevisaoInicio` date DEFAULT NULL,
  `DataInicio` date DEFAULT NULL,
  `DataFim` date DEFAULT NULL,
  `TotalHoras` int(11) NOT NULL DEFAULT '0',
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- painel.implantacoes_etapas definição

CREATE TABLE `implantacoes_etapas` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Implantacao` int(11) NOT NULL DEFAULT '0',
  `Etapa` varchar(75) DEFAULT NULL,
  `PervHoras` int(11) NOT NULL DEFAULT '0',
  `PrevInicio` date DEFAULT NULL,
  `DataInicio` date DEFAULT NULL,
  `DataFim` date DEFAULT NULL,
  `TotalHoras` int(11) NOT NULL DEFAULT '0',
  `Item` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- painel.kilometragem definição

CREATE TABLE `kilometragem` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `LocalVisita` varchar(100) NOT NULL DEFAULT 'Cliente visitado',
  `Usuario` int(11) unsigned NOT NULL DEFAULT '0',
  `Data` date NOT NULL DEFAULT '0000-00-00',
  `KmInicial` int(11) unsigned NOT NULL DEFAULT '0',
  `KmFinal` int(11) unsigned NOT NULL DEFAULT '0',
  `Veiculo` varchar(20) NOT NULL DEFAULT 'Moto',
  `Aprovado` char(1) NOT NULL DEFAULT 'N',
  `AprovadoPor` int(11) unsigned NOT NULL DEFAULT '0',
  `Agendamento` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;


-- painel.lancamentoscontas definição

CREATE TABLE `lancamentoscontas` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `IdConta` int(11) NOT NULL DEFAULT '0',
  `Plano` varchar(11) DEFAULT NULL,
  `Data` date DEFAULT NULL,
  `CreditoDebito` char(1) NOT NULL DEFAULT 'C',
  `Valor` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `Historico` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- painel.liberacoes definição

CREATE TABLE `liberacoes` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `UserSolicitou` int(11) unsigned NOT NULL DEFAULT '0',
  `Chave` varchar(14) DEFAULT NULL,
  `Motivo` varchar(250) DEFAULT NULL,
  `UserLiberou` int(11) unsigned NOT NULL DEFAULT '0',
  `Data` date DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=425 DEFAULT CHARSET=utf8;


-- painel.log definição

CREATE TABLE `log` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Data` date DEFAULT NULL,
  `Hora` time DEFAULT NULL,
  `Usuario` int(11) NOT NULL DEFAULT '0',
  `Tela` varchar(100) DEFAULT NULL,
  `Ocorrencia` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=928 DEFAULT CHARSET=utf8;


-- painel.modulos definição

CREATE TABLE `modulos` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `IdAplicacao` int(11) NOT NULL,
  `Aplicacao` varchar(20) NOT NULL DEFAULT '',
  `Modulo` varchar(20) NOT NULL DEFAULT '',
  `Ativo` char(1) NOT NULL DEFAULT 'S',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;


-- painel.notasversao definição

CREATE TABLE `notasversao` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Versao` varchar(15) DEFAULT NULL,
  `IdUser` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;


-- painel.permissoes_especiais definição

CREATE TABLE `permissoes_especiais` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Usuario` int(11) NOT NULL DEFAULT '0',
  `Modulo` char(1) NOT NULL DEFAULT 'D',
  `Permissao` varchar(255) DEFAULT NULL,
  `Descricao` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=296 DEFAULT CHARSET=utf8;


-- painel.planocontas definição

CREATE TABLE `planocontas` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Pai` int(11) NOT NULL DEFAULT '0',
  `Plano` varchar(11) DEFAULT NULL,
  `Descricao` varchar(100) DEFAULT NULL,
  `CredoraDevedora` char(1) NOT NULL DEFAULT 'C',
  `Ativa` char(1) NOT NULL DEFAULT 'S',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- painel.ramoatividade definição

CREATE TABLE `ramoatividade` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Atividade` varchar(100) DEFAULT NULL,
  `Ativa` char(1) NOT NULL DEFAULT 'S',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- painel.receber definição

CREATE TABLE `receber` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Titulo` int(11) unsigned NOT NULL DEFAULT '0',
  `Cliente` int(11) NOT NULL DEFAULT '0',
  `Tipo` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `Serie` varchar(3) DEFAULT NULL,
  `Faturamento` int(1) unsigned NOT NULL DEFAULT '0',
  `Valor` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `ParcRep` char(1) NOT NULL DEFAULT 'P',
  `Parcela` int(11) unsigned NOT NULL DEFAULT '0',
  `TotParcs` int(11) unsigned NOT NULL DEFAULT '0',
  `Emissao` date DEFAULT NULL,
  `Vencimento` date DEFAULT NULL,
  `UltPagamento` date DEFAULT NULL,
  `PrevPagamento` date DEFAULT NULL,
  `ValorPago` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `Desconto` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `Acrescimo` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `ValorTotal` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `Status` char(1) NOT NULL DEFAULT 'A',
  `Conciliado` char(1) DEFAULT 'N',
  `DataConciliacao` date DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- painel.relsalvo definição

CREATE TABLE `relsalvo` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Nome` varchar(250) DEFAULT NULL,
  `Data` date DEFAULT NULL,
  `Texto` longtext,
  `IdUser` int(11) unsigned NOT NULL DEFAULT '0',
  `NomeUser` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- painel.sistemas definição

CREATE TABLE `sistemas` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Sistema` varchar(15) DEFAULT NULL,
  `Ativo` char(1) NOT NULL DEFAULT 'S',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;


-- painel.sqlscripts definição

CREATE TABLE `sqlscripts` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `chave` varchar(50) DEFAULT NULL,
  `data` date DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=143 DEFAULT CHARSET=utf8;


-- painel.usuarios definição

CREATE TABLE `usuarios` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Nome` varchar(50) NOT NULL DEFAULT '',
  `Senha` varchar(20) NOT NULL DEFAULT '123456',
  `Ramal` smallint(4) unsigned zerofill NOT NULL DEFAULT '0000',
  `Celular` char(13) NOT NULL DEFAULT '(00)0000-0000',
  `Tele` char(1) NOT NULL DEFAULT 'N',
  `Analista` char(1) NOT NULL DEFAULT 'N',
  `Gerencial` char(1) NOT NULL DEFAULT 'N',
  `Pre` char(1) NOT NULL DEFAULT 'N',
  `Veiculo` varchar(20) DEFAULT NULL,
  `ValorKM` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `Ativo` char(1) NOT NULL DEFAULT 'S',
  `KmCarro` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `Implantacao` char(1) NOT NULL DEFAULT 'N',
  `Financeiro` char(1) DEFAULT 'N',
  `Comercial` char(1) DEFAULT 'N',
  `Setor` int(11) NOT NULL DEFAULT '0',
  `SalarioBase` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `PerfilComissao` int(11) NOT NULL DEFAULT '-1',
  `PercMA1` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `PercMA2` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `PercMA3` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `PercCI` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `SistemasQueAtende` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8;


-- painel.valecombustivel definição

CREATE TABLE `valecombustivel` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Data` date DEFAULT NULL,
  `IdUser` int(11) unsigned NOT NULL DEFAULT '0',
  `Veiculo` varchar(15) DEFAULT NULL,
  `Valor` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `Historico` varchar(75) DEFAULT NULL,
  `Cancelamento` char(1) DEFAULT 'N',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;