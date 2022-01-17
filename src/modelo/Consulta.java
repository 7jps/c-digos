package modelo;

import java.util.Calendar;

import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.PrimaryKeyJoinColumn;

@Entity
@PrimaryKeyJoinColumn(name="id")
@Inheritance(strategy = InheritanceType.JOINED)
public class Consulta {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;
	private String NomeCliente;
	private String NomeAnimal;
	private String Idade;
	private String raca;
	private String problema;
	private String medicamentos;
	private String observacao;
	private double Venda;
	
	@Enumerated(EnumType.STRING)	
	private TipoConsulta tipoconsulta = TipoConsulta.CIRURGIA;
	
	private Calendar dtCadastro = Calendar.getInstance();

	public Calendar getDtCadastro() {
		return dtCadastro;
	}

	public void setDtCadastro(Calendar dtCadastro) {
		this.dtCadastro = dtCadastro;
	}
	
	
	public TipoConsulta getTipoconsulta() {
		return tipoconsulta;
	}
	public void setTipoconsulta(TipoConsulta tipoconsulta) {
		this.tipoconsulta = tipoconsulta;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getNomeCliente() {
		return NomeCliente;
	}
	public void setNomeCliente(String nomeCliente) {
		NomeCliente = nomeCliente;
	}
	public String getNomeAnimal() {
		return NomeAnimal;
	}
	public void setNomeAnimal(String nomeAnimal) {
		NomeAnimal = nomeAnimal;
	}
	public String getIdade() {
		return Idade;
	}
	public void setIdade(String idade) {
		Idade = idade;
	}
	public String getRaca() {
		return raca;
	}
	public void setRaca(String raca) {
		this.raca = raca;
	}
	public String getProblema() {
		return problema;
	}
	public void setProblema(String problema) {
		this.problema = problema;
	}
	public String getMedicamentos() {
		return medicamentos;
	}
	public void setMedicamentos(String medicamentos) {
		this.medicamentos = medicamentos;
	}
	public String getObservacao() {
		return observacao;
	}
	public void setObservacao(String observacao) {
		this.observacao = observacao;
	}
	public double getVenda() {
		return Venda;
	}
	public void setVenda(double venda) {
		Venda = venda;
	}
	
}


