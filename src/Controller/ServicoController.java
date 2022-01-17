package Controller;

import java.util.List;

import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;

import dao.Dao;
import modelo.Servico;

@ManagedBean
@ViewScoped
public class ServicoController {
	private Servico servico = new Servico();
	
	public void gravar() {
		if(servico.getId()== null)
			new Dao<Servico>(Servico.class).adiciona(servico);
		else
			new Dao<Servico>(Servico.class).atualiza(servico);
		servico = new Servico();
	}
	
	public List<Servico> getTodosServicos(){
		return new Dao<Servico>(Servico.class).buscaTodos();
	}
	public void remover(Servico s) {
		new Dao<Servico>(Servico.class).remove(s.getId());
	}
	public void carregar(Servico s) {
		servico = s;
	}


	public Servico getServico() {
		return servico;
	}

	public void setServico(Servico servico) {
		this.servico = servico;
	}
	
	
	
}
