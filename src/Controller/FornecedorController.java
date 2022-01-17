package Controller;

import java.util.List;

import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;

import dao.Dao;

import modelo.Fornecedor;

@ManagedBean
@ViewScoped
public class FornecedorController{
private Fornecedor fornecedor = new Fornecedor();
	
	public void gravar() {
		if(fornecedor.getId()== null)
			new Dao<Fornecedor>(Fornecedor.class).adiciona(fornecedor);
		else
			new Dao<Fornecedor>(Fornecedor.class).atualiza(fornecedor);
		fornecedor = new Fornecedor();
	}
	public void remover(Fornecedor f) {
		new Dao<Fornecedor>(Fornecedor.class).remove(f.getId());
	}
	public void carregar(Fornecedor f) {
		fornecedor = f;
	}
	public List<Fornecedor> getTodosFornecedores(){
		return new Dao<Fornecedor>(Fornecedor.class).buscaTodos();
	}
	public Fornecedor getFornecedor() {
		return fornecedor;
	}
	public void setFornecedor(Fornecedor fornecedor) {
		this.fornecedor = fornecedor;
	}
}
