package Controller;

import java.util.List;

import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;

import dao.Dao;
import dao.OrdemDao;
import modelo.ItemServico;
import modelo.OrdemServico;
import modelo.Servico;

@ManagedBean
@ViewScoped
public class OrdemController {
	private OrdemServico ordemservico = new OrdemServico();
	private Integer qtde;
	private Integer servicoId;
	private double valor;
	
	
	public List<Servico> getTodosServicos(){
		return new Dao<Servico>(Servico.class).buscaTodos();
	}
	
	public void gravarItem(){
		Servico s = new Dao<Servico>(Servico.class).buscaPorId(servicoId);
		ItemServico item = new ItemServico();
		item.setServico(s);
		item.setQtde(qtde);
		item.setOrdemservico(ordemservico);
		//item.setValorUnitario(s.getValor());
		item.setValorUnitario(valor);
		
		ordemservico.getItens().add(item);
		qtde = 0;
		servicoId = null;
	}
	
	public List<ItemServico> getItensDoServico() {
		return ordemservico.getItens();
	}
	
	public void removerItem(ItemServico item){
		ordemservico.getItens().remove(item);
	}
	
	public void gravar(){
		if (this.ordemservico.getId() == null) {
			new Dao<OrdemServico>(OrdemServico.class).adiciona(ordemservico);
		} else {
			new Dao<OrdemServico>(OrdemServico.class).atualiza(ordemservico);
		}
		
		this.ordemservico = new OrdemServico();
	}

	public List<OrdemServico> getTodasOrdens(){
		return new Dao<OrdemServico>(OrdemServico.class).buscaTodos();
	}
	
	public void remover(OrdemServico o){
		new Dao<OrdemServico>(OrdemServico.class).remove(o.getId());
	}
	
	public void carregar(OrdemServico o){
		ordemservico = new OrdemDao().listaPorId(o);
	}
	
	public OrdemServico getOrdemservico() {
		return ordemservico;
	}
	public void setOrdemservico(OrdemServico ordemservico) {
		this.ordemservico = ordemservico;
	}
	public Integer getQtde() {
		return qtde;
	}
	public void setQtde(Integer qtde) {
		this.qtde = qtde;
	}
	public Integer getServicoId() {
		return servicoId;
	}
	public void setServicoId(Integer servicoId) {
		this.servicoId = servicoId;
	}	
	public double getValor() {
		return valor;
	}

	public void setValor(double valor) {
		this.valor = valor;
	}
}
