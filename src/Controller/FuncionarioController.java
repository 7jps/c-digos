package Controller;

import java.util.List;

import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;

import dao.Dao;
import modelo.Cargo;
import modelo.Funcionario;

@ManagedBean
@ViewScoped
public class FuncionarioController extends PessoaController{
private Funcionario funcionario = new Funcionario();
	
	public void gravar() {
		if(funcionario.getId()== null)
			new Dao<Funcionario>(Funcionario.class).adiciona(funcionario);
		else
			new Dao<Funcionario>(Funcionario.class).atualiza(funcionario);
		funcionario = new Funcionario();
	}
	
	public void remover(Funcionario f) {
		new Dao<Funcionario>(Funcionario.class).remove(f.getId());
	}
	public void carregar(Funcionario f) {
		funcionario = f;
	}
	public List<Funcionario> getTodosFuncionarios(){
		return new Dao<Funcionario>(Funcionario.class).buscaTodos();
	}

	public Funcionario getFuncionario() {
		return funcionario;
	}

	public void setFuncionario(Funcionario funcionario) {
		this.funcionario = funcionario;
	}	
	public List<Cargo> getTodosCargos(){
		return new Dao<Cargo>(Cargo.class).buscaTodos();
	}
	
	
}
