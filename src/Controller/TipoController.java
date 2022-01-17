package Controller;

import java.util.List;

import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;

import dao.Dao;
import modelo.Tipo;

@ManagedBean
@ViewScoped
public class TipoController {
	
	private Tipo tipo = new Tipo();

	public Tipo getTipo() {
		return tipo;
	}

	public void setTipo(Tipo tipo) {
		this.tipo = tipo;
	}
	public void gravar() {
		if(tipo.getId() == null)
			new Dao<Tipo>(Tipo.class).adiciona(tipo);
		else
			new Dao<Tipo>(Tipo.class).atualiza(tipo);
		tipo = new Tipo();
	}
	public List<Tipo> getTodosTipos(){
		return new Dao<Tipo>(Tipo.class).buscaTodos();
	}
	public void remover(Tipo t) {
		new Dao<Tipo>(Tipo.class).remove(t.getId());
	}
	public void carregar(Tipo t) {
		tipo = t;
	}

}
