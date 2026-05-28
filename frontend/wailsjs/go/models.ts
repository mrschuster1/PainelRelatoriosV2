export namespace models {
	
	export class Atendimento {
	    id: number;
	    cliente: string;
	    pessoa: string;
	    categoria: string;
	    acao: string;
	    fechado: string;
	    // Go type: time
	    dataAbertura?: any;
	    horaAbertura: string;
	    // Go type: time
	    dataFechamento?: any;
	    atendente: string;
	    setor: string;
	    sistema: string;
	    historico: string;
	
	    static createFrom(source: any = {}) {
	        return new Atendimento(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.id = source["id"];
	        this.cliente = source["cliente"];
	        this.pessoa = source["pessoa"];
	        this.categoria = source["categoria"];
	        this.acao = source["acao"];
	        this.fechado = source["fechado"];
	        this.dataAbertura = this.convertValues(source["dataAbertura"], null);
	        this.horaAbertura = source["horaAbertura"];
	        this.dataFechamento = this.convertValues(source["dataFechamento"], null);
	        this.atendente = source["atendente"];
	        this.setor = source["setor"];
	        this.sistema = source["sistema"];
	        this.historico = source["historico"];
	    }
	
		convertValues(a: any, classs: any, asMap: boolean = false): any {
		    if (!a) {
		        return a;
		    }
		    if (a.slice && a.map) {
		        return (a as any[]).map(elem => this.convertValues(elem, classs));
		    } else if ("object" === typeof a) {
		        if (asMap) {
		            for (const key of Object.keys(a)) {
		                a[key] = new classs(a[key]);
		            }
		            return a;
		        }
		        return new classs(a);
		    }
		    return a;
		}
	}
	export class AtendimentoFilter {
	    dataInicio: string;
	    dataFim: string;
	    tipoData: string;
	    atendentes: string[];
	    clientes: string[];
	    sistemas: string[];
	    categorias: string[];
	    setores: string[];
	    acoes: string[];
	    unidades: string[];
	    groups: string[];
	    sortField: string;
	    sortOrder: string;
	
	    static createFrom(source: any = {}) {
	        return new AtendimentoFilter(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.dataInicio = source["dataInicio"];
	        this.dataFim = source["dataFim"];
	        this.tipoData = source["tipoData"];
	        this.atendentes = source["atendentes"];
	        this.clientes = source["clientes"];
	        this.sistemas = source["sistemas"];
	        this.categorias = source["categorias"];
	        this.setores = source["setores"];
	        this.acoes = source["acoes"];
	        this.unidades = source["unidades"];
	        this.groups = source["groups"];
	        this.sortField = source["sortField"];
	        this.sortOrder = source["sortOrder"];
	    }
	}
	export class HistoricoAtendimento {
	    id: number;
	    atendimento: number;
	    data: string;
	    hora: string;
	    histAcao: string;
	    historico: string;
	
	    static createFrom(source: any = {}) {
	        return new HistoricoAtendimento(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.id = source["id"];
	        this.atendimento = source["atendimento"];
	        this.data = source["data"];
	        this.hora = source["hora"];
	        this.histAcao = source["histAcao"];
	        this.historico = source["historico"];
	    }
	}
	export class LookupOption {
	    id: string;
	    label: string;
	
	    static createFrom(source: any = {}) {
	        return new LookupOption(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.id = source["id"];
	        this.label = source["label"];
	    }
	}
	export class User {
	    id: number;
	    nome: string;
	    senha: string;
	    ativo: string;
	
	    static createFrom(source: any = {}) {
	        return new User(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.id = source["id"];
	        this.nome = source["nome"];
	        this.senha = source["senha"];
	        this.ativo = source["ativo"];
	    }
	}

}

export namespace repository {
	
	export class FilterPreset {
	    id: number;
	    name: string;
	    filter_json: string;
	    user_id: number;
	    user_name: string;
	
	    static createFrom(source: any = {}) {
	        return new FilterPreset(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.id = source["id"];
	        this.name = source["name"];
	        this.filter_json = source["filter_json"];
	        this.user_id = source["user_id"];
	        this.user_name = source["user_name"];
	    }
	}

}

