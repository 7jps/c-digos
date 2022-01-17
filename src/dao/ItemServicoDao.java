package dao;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;

import modelo.ItemServico;
import modelo.OrdemServico;

public class ItemServicoDao {
	public List<ItemServico> listaPorComanda(OrdemServico o) {
		EntityManager em = JPAUtil.getEntityManager();
		
		String jpql = "SELECT i FROM ItemServico i WHERE i.ordemservico = :pOrdemServico";
		
		TypedQuery<ItemServico> query = em.createQuery(jpql, ItemServico.class);
		query.setParameter("pOrdemServico", o);
		
		List<ItemServico> lista = query.getResultList();
		
		em.close();
		
		return lista;
	}
}
