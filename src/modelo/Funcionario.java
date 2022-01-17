package modelo;

import java.util.Calendar;

import javax.persistence.Entity;
import javax.persistence.OneToOne;
import javax.persistence.PrimaryKeyJoinColumn;

@Entity
@PrimaryKeyJoinColumn(name = "id")	
public class Funcionario extends Pessoa{
	private double salario;
	
	@OneToOne
	private Cargo cargo;
	private String senha;
	
	public String getSenha() {
		return senha;
	}

	public void setSenha(String senha) {
		this.senha = senha;
	}

	private Calendar dtAdmissao = Calendar.getInstance();

	public double getSalario() {
		return salario;
	}

	public void setSalario(double salario) {
		this.salario = salario;
	}

	public Cargo getCargo() {
		return cargo;
	}

	public void setCargo(Cargo cargo) {
		this.cargo = cargo;
	}

	public Calendar getDtAdmissao() {
		return dtAdmissao;
	}

	public void setDtAdmissao(Calendar dtAdmissao) {
		this.dtAdmissao = dtAdmissao;
	}

}
