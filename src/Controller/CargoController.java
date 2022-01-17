package Controller;

import java.util.List;

import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;

import dao.Dao;
import modelo.Cargo;

@ManagedBean
@ViewScoped
public class CargoController {
private Cargo cargo = new Cargo();
	
	public void gravar() {
		if(cargo.getId()== null)
			new Dao<Cargo>(Cargo.class).adiciona(cargo);
		else
			new Dao<Cargo>(Cargo.class).atualiza(cargo);
		cargo = new Cargo();
	}
	public void remover(Cargo c) {
		new Dao<Cargo>(Cargo.class).remove(c.getId());
	}
	public void carregar(Cargo c) {
		cargo = c;
	}
	public List<Cargo> getTodosCargos(){
		return new Dao<Cargo>(Cargo.class).buscaTodos();
	}
	public Cargo getCargo() {
		return cargo;
	}
	public void setCargo(Cargo cargo) {
		this.cargo = cargo;
	}
}
