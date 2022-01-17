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


@Entity
@Inheritance(strategy = InheritanceType.JOINED)
public class Animal {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;
	private String nome;
	private int idade;
	private String raca;
	private String pelagem;
	private String dono;
	
	@Enumerated(EnumType.STRING)	
	private SexoAnimal sexoanimal = SexoAnimal.FEMEA;
	
	public String getDono() {
		return dono;
	}

	public void setDono(String dono) {
		this.dono = dono;
	}

	@Enumerated(EnumType.STRING)	
	private TipoAnimal tipoanimal = TipoAnimal.CACHORRO;
	
	private Calendar dtCadastro = Calendar.getInstance();
	
	public Calendar getDtCadastro() {
		return dtCadastro;
	}

	public void setDtCadastro(Calendar dtCadastro) {
		this.dtCadastro = dtCadastro;
	}
	
	public SexoAnimal getSexoanimal() {
		return sexoanimal;
	}

	public void setSexoanimal(SexoAnimal sexoanimal) {
		this.sexoanimal = sexoanimal;
	}

	public TipoAnimal getTipoanimal() {
		return tipoanimal;
	}
	public void setTipoanimal(TipoAnimal tipoanimal) {
		this.tipoanimal = tipoanimal;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getNome() {
		return nome;
	}
	public void setNome(String nome) {
		this.nome = nome;
	}
	public int getIdade() {
		return idade;
	}
	public void setIdade(int idade) {
		this.idade = idade;
	}
	public String getRaca() {
		return raca;
	}
	public void setRaca(String raca) {
		this.raca = raca;
	}

	public String getPelagem() {
		return pelagem;
	}

	public void setPelagem(String pelagem) {
		this.pelagem = pelagem;
	}


}
