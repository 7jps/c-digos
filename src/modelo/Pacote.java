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
public class Pacote {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer Id;
	private double subtotal;
	private double acrescimos;
	private double desconto;
	
	@Enumerated(EnumType.STRING)	
	private TipoPacote tipopacote = TipoPacote.MENSAL;
	
	private Calendar dtCadastro = Calendar.getInstance();

	public Calendar getDtCadastro() {
		return dtCadastro;
	}

	public void setDtCadastro(Calendar dtCadastro) {
		this.dtCadastro = dtCadastro;
	}
	
	public double getSubtotal() {
		return subtotal;
	}
	public void setSubtotal(double subtotal) {
		this.subtotal = subtotal;
	}
	public TipoPacote getTipopacote() {
		return tipopacote;
	}
	public void setTipopacote(TipoPacote tipopacote) {
		this.tipopacote = tipopacote;
	}
	public void setId(Integer id) {
		Id = id;
	}
	private double total;
	
	public double getSub_total() {
		return subtotal;
	}
	public void setSub_total(double subtotal) {
		this.subtotal = subtotal;
	}
	public double getAcrescimos() {
		return acrescimos;
	}
	public void setAcrescimos(double acrescimos) {
		this.acrescimos = acrescimos;
	}
	public double getDesconto() {
		return desconto;
	}
	public void setDesconto(double desconto) {
		this.desconto = desconto;
	}
	public double getTotal() {
		return total;
	}
	public void setTotal(double total) {
		this.total = total;
	}
	public Integer getId() {
		return Id;
	}
	
}
