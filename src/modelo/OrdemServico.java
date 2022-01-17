package modelo;

import java.util.Calendar;
import java.util.LinkedList;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
public class OrdemServico {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;
	private Double valor;

	@Temporal(TemporalType.DATE)
	private Calendar dtOrdem = Calendar.getInstance();

	@OneToMany(cascade=CascadeType.ALL, orphanRemoval = true, mappedBy = "ordemservico")
	private List<ItemServico> itens = new LinkedList<ItemServico>();
	
	public void add(ItemServico item) {
		this.itens.add(item);
	}
	
	public Double getValorTotal() {
		valor = 0.0;
		for(ItemServico item : itens) {
			valor = valor + item.getQtde()*item.getValorUnitario();
		}
		return valor;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Double getValor() {
		return valor;
	}

	public void setValor(Double valor) {
		this.valor = valor;
	}

	public Calendar getDtOrdem() {
		return dtOrdem;
	}

	public void setDtOrdem(Calendar dtOrdem) {
		this.dtOrdem = dtOrdem;
	}
	public List<ItemServico> getItens() {
		return itens;
	}

	public void setItens(List<ItemServico> itens) {
		this.itens = itens;
	}
}
