package Controller;

import java.util.List;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
import dao.Dao;
import modelo.Cliente;

@ManagedBean
@ViewScoped
public class ClienteController extends PessoaController{
	private Cliente cliente = new Cliente();
	
	public void gravar() {
		super.gravar(cliente);
		cliente = new Cliente();
	}
	public void remover(Cliente c) {
		new Dao<Cliente>(Cliente.class).remove(c.getId());
	}
	public void carregar(Cliente c) {
		cliente = c;
	}
	public List<Cliente> getTodosClientes(){
		return new Dao<Cliente>(Cliente.class).buscaTodos();
	}

	public Cliente getCliente() {
		return cliente;
	}

	public void setCliente(Cliente cliente) {
		this.cliente = cliente;
	}
}
