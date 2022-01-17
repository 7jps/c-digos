package Controller;

import java.util.List;

import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
import dao.Dao;
import modelo.Produto;
import modelo.Tipo;

@ManagedBean
@ViewScoped
public class ProdutoController {
	private Produto produto = new Produto();
	//atributo para guardar o id do tipo desejado
	private Integer idTipo;
	
	public Produto getProduto() {
		return produto;
	}
	
	public void setProduto(Produto produto) {
		this.produto = produto;
	}
	
	public void gravar() {
		Tipo t = new Dao<Tipo>(Tipo.class).buscaPorId(idTipo);
		produto.setTipo(t);
		
		if(produto.getId()== null)
			new Dao<Produto>(Produto.class).adiciona(produto);
		else
			new Dao<Produto>(Produto.class).atualiza(produto);
		produto = new Produto();
		idTipo = null;
	}
	public List<Produto> getTodosProdutos(){
		return new Dao<Produto>(Produto.class).buscaTodos();
	}
	public void remover(Produto p) {
		new Dao<Produto>(Produto.class).remove(p.getId());
	}
	public void carregar(Produto p) {
		produto = p;
		idTipo = p.getTipo().getId();
	}
	//Retorna uma lista de todos os tipos
	public List<Tipo> getTodosTipos(){
		return new Dao<Tipo>(Tipo.class).buscaTodos();
	}

	public Integer getIdTipo() {
		return idTipo;
	}

	public void setIdTipo(Integer idTipo) {
		this.idTipo = idTipo;
	}
}
